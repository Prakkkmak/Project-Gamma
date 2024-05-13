class_name DebugPanel
extends PanelContainer


signal spawn_fish_required(variant: int)
signal spawn_plant_required(variant: int)
signal spawn_food_required(variant: int)


@onready var spawn_fish_1_button: Button = $VBoxContainer/SpawnFish1Button
@onready var spawn_fish_2_button: Button = $VBoxContainer/SpawnFish2Button
@onready var spawn_plant_1_button: Button = $VBoxContainer/SpawnPlant1Button
@onready var spawn_food_1_button: Button = $VBoxContainer/SpawnFoodButton

func _ready() -> void:
	spawn_fish_1_button.pressed.connect(_on_spawn_fish_1_button_pressed)
	spawn_fish_2_button.pressed.connect(_on_spawn_fish_2_button_pressed)
	spawn_plant_1_button.pressed.connect(_on_spawn_plant_1_button_pressed)
	spawn_food_1_button.pressed.connect(_on_spawn_food_1_button_pressed)


func _on_spawn_fish_1_button_pressed() -> void:
	spawn_fish_required.emit(1)


func _on_spawn_fish_2_button_pressed() -> void:
	spawn_fish_required.emit(2)


func _on_spawn_plant_1_button_pressed() -> void:
	spawn_plant_required.emit(1)


func _on_spawn_food_1_button_pressed() -> void:
	spawn_food_required.emit(1)
