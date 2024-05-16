class_name Aquarium
extends Node2D

signal income_perseved(income: float)
signal happiness_updated(entity_infos: EntityInfos, hapiness: HappinessStats)
signal oxygen_updated(new_value: float)
signal count_updated(entity_infos: EntityInfos, count: int)

## Second per aquarium tick
@export var seconds_per_tick: float = 10.0
## Quality in percent is 0 to 100
@export_range(0,100) var quality: float = 100.0
## Acidity in pH 0 to 14 with 7 neutral
@export_range(0,100) var acidity: float = 100.0
## Temperatire 10 to 40 with 21 as neutral
@export_range(0,100) var temperature: float = 100.0
## Saturation of oxygen, 100 is perfect
@export_range(0,100) var oxygen: float = 100.0

@export var fish_scene: PackedScene
@export var plant_scene: PackedScene
@export var fish_food_scene: PackedScene


@onready var navigation_region: NavigationRegion2D = %NavigationRegion2D


@onready var entities_node: Node2D = %EntitiesNode
@onready var ground_slots: Node2D = %Slots/Ground

# Dic of EntityInfos: Array[Node2D]
var entities: Dictionary = {}


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
		happiness_stats.add_feature(HappinessStats.HappinessFeatureType.FOOD, food_ratio)
	
	#Calculate oxygen satisfaction
	var current_oxygen_ratio: float = abs(living_infos.get_target_oxygen() - oxygen) / living_infos.get_maximum_gap_oxygen()
	happiness_stats.add_feature(HappinessStats.HappinessFeatureType.OXYGEN, 1.0 - current_oxygen_ratio)
	
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
	entity.tree_exited.connect(_on_untrack_entity.bind(entity))


func _update_constants(delta: float) -> void:
	var income: float = 0.0
	for entity: Node in all_entites():
		var entity_infos: EntityInfos = entity.get("infos") as EntityInfos
		if !entity_infos:
			return
		temperature += entity_infos.temperature_variation * delta / seconds_per_tick
		quality += entity_infos.quality_variation * delta / seconds_per_tick
		acidity += entity_infos.acidity_variation * delta / seconds_per_tick
		oxygen += entity_infos.oxygen_variation * delta / seconds_per_tick
		income += entity_infos.income_variation * delta / seconds_per_tick
	for entity_infos: EntityInfos in entities.keys():
		var happiness: HappinessStats = get_happiness(entity_infos)
		happiness_updated.emit(entity_infos, happiness)
	oxygen_updated.emit(oxygen)
	income_perseved.emit(income)


func _on_untrack_entity(entity: Node) -> void:
	entities.erase(entity)
