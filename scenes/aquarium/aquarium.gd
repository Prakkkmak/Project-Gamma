class_name Aquarium
extends Node2D

signal income_perseved(income: float)
signal happiness_updated(entity_infos: EntityInfos, hapiness: HappinessStats)
signal oxygen_updated(new_value: float)
signal count_updated(entity_infos: EntityInfos, count: int)

signal stat_updated(stat: Stat, old_value: float, new_value: float)

## Second per aquarium tick
@export var seconds_per_tick: float = 10.0


@export var stats: Array[Stat] = []


@export var fish_scene: PackedScene
@export var plant_scene: PackedScene
@export var fish_food_scene: PackedScene


@onready var navigation_region: NavigationRegion2D = %NavigationRegion2D


@onready var entities_node: Node2D = %EntitiesNode
@onready var ground_slots: Node2D = %Slots/Ground
@onready var quality_overlay: Polygon2D = %QualityOverlay

# Dic of EntityInfos: Array[Node2D]
var entities: Dictionary = {}

var quality_filter_color: Color = Color.TRANSPARENT

func _ready() -> void:
	quality_filter_color = quality_overlay.color


func _process(delta: float) -> void:
	_update_constants(delta)
	

func add_fish(fish_infos: FishInfos, position: Vector2 = Vector2.ZERO) -> void:
	var fish: Fish = fish_scene.instantiate()
	fish.infos = fish_infos
	fish.aquarium = self
	entities_node.add_child(fish)
	fish.global_position = position
	_track_entity(fish_infos, fish)


func add_plant(plant_infos: PlantInfos,  position: Vector2 = Vector2.ZERO) -> void:
	var plant: Plant = plant_scene.instantiate()
	plant.infos = plant_infos
	var slot_nodes: Array[Node] = ground_slots.get_children()
	plant.aquarium = self
	for node: Node in slot_nodes:
		if !(node is Node2D):
			continue
		var slot: Node2D = node
		if slot.get_child_count() > 0:
			continue
		slot.add_child(plant)
		_track_entity(plant_infos, plant)
		break

func add_food(food_infos: FoodInfos, position: Vector2 = Vector2.ZERO) -> void:
	var fish_food: FishFood = fish_food_scene.instantiate()
	fish_food.infos = food_infos
	fish_food.global_position = Vector2(position)
	entities_node.add_child(fish_food)
	_track_entity(food_infos, fish_food)


func get_happiness(entity_infos: EntityInfos) -> HappinessStats:
	if !entities.has(entity_infos) || !(entity_infos is LivingInfos):
		return null
	var current_entities: Array[Node] = []
	current_entities.assign(entities[entity_infos] as Array)
	var happiness_stats: HappinessStats = HappinessStats.new()
	var living_infos: LivingInfos = entity_infos as LivingInfos
	
	#Calculate food satisfaction
	if living_infos is FishInfos:
		var sum_food: float = 0.0
		for current_entity: Node in current_entities:
			var fish: Fish = current_entity as Fish
			sum_food += fish.current_food
		var average_food: float = sum_food / current_entities.size()
		var food_ratio: float = average_food / (living_infos as FishInfos).food_threshold
		happiness_stats.add_feature("food", food_ratio)
	
	#Calculate stats satisfactions
	#TODO
	for stat_requirement: StatRequirement in living_infos.stats_requirements:
		var current_stat_ratio: float = abs(stat_requirement.target - stat_requirement.stat.current_value) / stat_requirement.get_gap()
		happiness_stats.add_feature(stat_requirement.stat.id, 1.0 - current_stat_ratio)
	return happiness_stats


func all_entites() -> Array[Node] :
	var current_all_entities: Array[Node] = []
	for entity_array: Array in entities.values():
		current_all_entities.append_array(entity_array)
	return current_all_entities


func _track_entity(infos: EntityInfos, entity: Node) -> void:
	if !entities.has(infos):
		entities[infos] = []
	(entities[infos] as Array[Node]).append(entity)
	count_updated.emit(infos, (entities[infos] as Array).size())
	entity.tree_exited.connect(_on_untrack_entity.bind(infos, entity))


func _update_constants(delta: float) -> void:
	var income: float = 0.0
	for entity: Node in all_entites():
		var entity_infos: EntityInfos = entity.get("infos") as EntityInfos
		if !entity_infos:
			return
		for stat: Stat in stats:
			var old_value: float = stat.current_value
			var stat_variation: StatVariation = entity_infos.get_stat_variation(stat)
			if stat_variation:
				stat.apply_variation(stat_variation.get_variation() * delta / seconds_per_tick)
			if stat.id == "quality":
				quality_overlay.color = lerp(quality_filter_color, Color.TRANSPARENT, stat.current_value / 100)
			stat_updated.emit(stat, old_value, stat.current_value)
		income += entity_infos.income_variation * delta / seconds_per_tick
		income_perseved.emit(income)
	for entity_infos: EntityInfos in entities.keys():
		var happiness: HappinessStats = get_happiness(entity_infos)
		happiness_updated.emit(entity_infos, happiness)



func _on_untrack_entity(infos: EntityInfos, entity: Node) -> void:
	(entities[infos] as Array).erase(entity)
	count_updated.emit(infos, (entities[infos] as Array).size())
