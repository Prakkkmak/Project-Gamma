class_name Main
extends Node

@export var fish_infos: Array[FishInfos] = []
@export var plant_infos: Array[PlantInfos] = []

@onready var aquarium: Aquarium = %Aquarium
@onready var debug_panel: DebugPanel = $CanvasLayer/DebugPanel


func _ready() -> void:
	debug_panel.spawn_fish_requested.connect(_on_spawn_fish_requested)
	debug_panel.spawn_plant_requested.connect(_on_spawn_plant_requested)
	debug_panel.spawn_food_requested.connect(_on_spawn_food_requested)


func _on_spawn_fish_requested(variant: int) -> void:
	var selected_fish_infos: FishInfos = fish_infos[variant - 1]
	aquarium.add_fish(selected_fish_infos)


func _on_spawn_plant_requested(variant: int) -> void:
	var selected_plant_infos: PlantInfos = plant_infos[variant - 1]
	aquarium.add_plant(selected_plant_infos)
	

func _on_spawn_food_requested(variant: int) -> void:
	var pos: Vector2 = Vector2(randi_range(-400,400),-200)
	aquarium.add_food(pos)
