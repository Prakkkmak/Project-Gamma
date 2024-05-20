class_name Aquarium
extends Node2D

signal income_perseved(income: float)
signal happiness_updated(entity_infos: EntityInfos, hapiness: HappinessStats)
signal oxygen_updated(new_value: float)
signal count_updated(entity_infos: EntityInfos, count: int)

signal stat_updated(stat: Stat, new_value: float)

## Second per aquarium tick
@export var seconds_per_tick: float = 60.0


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

var slot_previewed: Node2D


func _ready() -> void:
	quality_filter_color = quality_overlay.color


func _process(delta: float) -> void:
	_update_constants(delta / seconds_per_tick)
	

func add_fish(fish_infos: FishInfos, position: Vector2 = Vector2.ZERO) -> void:
	var fish: Fish = fish_scene.instantiate()
	fish.infos = fish_infos
	fish.aquarium = self
	entities_node.add_child(fish)
	fish.global_position = position
	_track_entity(fish_infos, fish)


func get_close_slot(position: Vector2) -> Node2D:
	var slot_nodes: Array[Node] = ground_slots.get_children()
	if slot_nodes.size() == 0:
		return null
	var closer_slot: Node2D = slot_nodes[0] as Node2D
	for slot_node in slot_nodes:
		if slot_node is Node2D:
			if (slot_node as Node2D).global_position.distance_to(position) < closer_slot.global_position.distance_to(position):
				closer_slot = slot_node as Node2D
	return closer_slot


func preview_plant(plant_infos: PlantInfos,  position: Vector2 = Vector2.ZERO) -> void:
	var closed_node: Node2D = get_close_slot(position)
	if slot_previewed == closed_node:
		return
	if closed_node.get_children().size() > 0:
		return
	if slot_previewed && slot_previewed.get_child(0):
		slot_previewed.get_child(0).queue_free()
	var plant: Plant = plant_scene.instantiate()
	plant.infos = plant_infos
	closed_node.add_child(plant)
	slot_previewed = closed_node
	plant.modulate = plant.modulate.lerp(Color.TRANSPARENT, 0.5)

func unpreview() -> void:
	if slot_previewed && slot_previewed.get_child(0):
			slot_previewed.get_child(0).queue_free()

func add_plant(plant_infos: PlantInfos,  position: Vector2 = Vector2.ZERO) -> bool:
	var plant: Plant = plant_scene.instantiate()
	plant.infos = plant_infos
	plant.aquarium = self
	if !slot_previewed || slot_previewed.get_child_count() == 0:
		return false
	slot_previewed.get_child(0).queue_free()
	slot_previewed.add_child(plant)
	slot_previewed = null
	_track_entity(plant_infos, plant)
	return true


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
		happiness_stats.add_feature("Food", food_ratio)
	for stat_requirement: StatRequirement in living_infos.stats_requirements:
		var current_stat_ratio: float = abs(stat_requirement.target - stat_requirement.stat.current_value) / stat_requirement.get_gap()
		happiness_stats.add_feature(stat_requirement.stat.display_name, 1.0 - current_stat_ratio)
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
	for stat in stats:
		if stat.one_shot:
			stat.current_value = 0
	for entity: Node in all_entites():
		var entity_infos: EntityInfos = entity.get("infos") as EntityInfos
		if !entity_infos:
			return
		for stat_variation: StatVariation in entity_infos.stats_variations:
			if stat_variation:
				if stat_variation.stat.one_shot:
					stat_variation.stat.apply_variation(stat_variation.get_variation())
				else:
					stat_variation.stat.apply_variation(stat_variation.get_variation() * delta)
			if stat_variation.stat.id == "quality":
				quality_overlay.color = lerp(quality_filter_color, Color.TRANSPARENT, stat_variation.stat.current_value / 100)
		income += entity_infos.income_variation * delta
		income_perseved.emit(income)
	for stat: Stat in stats:
		GameEvents.update_stat(stat, stat.current_value, self)
		stat_updated.emit(stat, stat.current_value)
	for entity_infos: EntityInfos in entities.keys():
		var happiness: HappinessStats = get_happiness(entity_infos)
		happiness_updated.emit(entity_infos, happiness)



func _on_untrack_entity(infos: EntityInfos, entity: Node) -> void:
	(entities[infos] as Array).erase(entity)
	count_updated.emit(infos, (entities[infos] as Array).size())
