class_name Plant
extends Node2D


@export var infos: PlantInfos


@onready var food_component: FoodComponent = $FoodComponent
@onready var food_component_2: FoodComponent = $FoodComponent2


func _process(delta: float) -> void:
	food_component.add_food(delta)
	food_component_2.add_food(delta)
