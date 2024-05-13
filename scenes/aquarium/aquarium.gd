class_name Aquarium
extends Node2D


@export var fish_scene: PackedScene
@export var plant_scene: PackedScene
@export var fish_food_scene: PackedScene


@onready var entities: Node2D = %Entities
@onready var ground_slots: Node2D = %Slots/Ground

var fishs: Array[Fish] = []

func add_fish(fish_infos: FishInfos, position: Vector2 = Vector2.ZERO) -> void:
	var fish: Fish = fish_scene.instantiate()
	fish.infos = fish_infos
	fish.position = position
	entities.add_child(fish)
	fishs.append(fish)


func add_plant(plant_infos: PlantInfos,  position: Vector2 = Vector2.ZERO) -> void:
	var plant: Plant = plant_scene.instantiate()
	plant.infos = plant_infos
	var slot_nodes: Array[Node] = ground_slots.get_children()
	for node: Node in slot_nodes:
		if !(node is Node2D):
			continue
		var slot: Node2D = node
		if slot.get_child_count() > 0:
			continue
		slot.add_child(plant)

func add_food(position: Vector2 = Vector2.ZERO) -> void:
	var fish_food: FishFood = fish_food_scene.instantiate()
	fish_food.global_position = Vector2(position.x,-300)
	entities.add_child(fish_food)
