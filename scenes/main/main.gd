class_name Main
extends Node

@export var fish_scene: PackedScene
@export var fish_food_scene: PackedScene

@export var fish_infos: Array[FishInfos] = []

@onready var aquarium: Node2D = %Aquarium
@onready var debug_panel: DebugPanel = $CanvasLayer/DebugPanel


func _ready() -> void:
	debug_panel.spawn_fish_required.connect(_on_spawn_fish_required)
	debug_panel.spawn_plant_required.connect(_on_spawn_plant_required)
	debug_panel.spawn_food_required.connect(_on_spawn_food_required)


func _on_spawn_fish_required(variant: int) -> void:
	var selected_fish_infos: FishInfos = fish_infos[variant - 1]
	var fish: Fish = fish_scene.instantiate()
	fish.infos = selected_fish_infos
	aquarium.add_child(fish)


func _on_spawn_plant_required(variant: int) -> void:
	pass
	

func _on_spawn_food_required(variant: int) -> void:
	var fish_food: FishFood = fish_food_scene.instantiate()
	fish_food.global_position = Vector2(randi_range(-400,400),-200)
	aquarium.add_child(fish_food)
