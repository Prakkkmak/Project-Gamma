class_name Aquarium
extends Node2D

signal income_perseved(income: float)


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


@onready var temperature_label: Label = %TemperatureLabel
@onready var quality_label: Label = %QualityLabel
@onready var acidity_label: Label = %AcidityLabel
@onready var oxygen_label: Label = %OxygenLabel
@onready var navigation_region: NavigationRegion2D = %NavigationRegion2D


@onready var entities_node: Node2D = %EntitiesNode
@onready var ground_slots: Node2D = %Slots/Ground


var entities: Array[Node] = []


func _ready() -> void:
	_update_temperature_label()
	_update_quality_label()
	_update_acidity_label()
	_update_oxygen_label()


func _process(delta: float) -> void:
	_update_constants(delta)

func add_fish(fish_infos: FishInfos, position: Vector2 = Vector2.ZERO) -> void:
	var fish: Fish = fish_scene.instantiate()
	fish.infos = fish_infos
	fish.aquarium = self
	entities_node.add_child(fish)
	fish.global_position = position
	_track_entity(fish)


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
		_track_entity(plant)
		break

func add_food(food_infos: FoodInfos, position: Vector2 = Vector2.ZERO) -> void:
	var fish_food: FishFood = fish_food_scene.instantiate()
	fish_food.infos = food_infos
	fish_food.global_position = Vector2(position)
	entities_node.add_child(fish_food)
	_track_entity(fish_food)


func _track_entity(entity: Node) -> void:
	entities.append(entity)
	entity.tree_exited.connect(_on_untrack_entity.bind(entity))


func _update_constants(delta: float) -> void:
	var income: float = 0.0
	for entity: Node in entities:
		var entity_infos: EntityInfos = entity.get("infos") as EntityInfos
		if !entity_infos:
			return
		temperature += entity_infos.temperature_variation * delta / seconds_per_tick
		quality += entity_infos.quality_variation * delta / seconds_per_tick
		acidity += entity_infos.acidity_variation * delta / seconds_per_tick
		oxygen += entity_infos.oxygen_variation * delta / seconds_per_tick
		income += entity_infos.income_variation * delta / seconds_per_tick
	income_perseved.emit(income)
	quality = clamp(quality, 0, 100)
	_update_temperature_label()
	_update_quality_label()
	_update_acidity_label()
	_update_oxygen_label()


func _update_temperature_label() -> void:
	temperature_label.text = "Temperature: " + str(ceil(temperature)) + " °C"


func _update_quality_label() -> void:
	quality_label.text = "Quality: " + str(ceil(quality)) + " ppm"


func _update_acidity_label() -> void:
	acidity_label.text = "Acidity: " + str(ceil(acidity)) + " pH"


func _update_oxygen_label() -> void:
	oxygen_label.text = "Oxygen Saturation: " + str(ceil(oxygen)) + "%"


func _on_untrack_entity(entity: Node) -> void:
	entities.erase(entity)
