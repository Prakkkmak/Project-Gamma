class_name FoodComponent
extends Node2D


signal depleted
signal eated(old_amount: float, new_amount: float)



@export var food_type: Enums.FoodType = Enums.FoodType.VEGETABLE
@export var max_food: float = 10.0


@onready var current_food: float = max_food


func eat(value: float = 0.0) -> float:
	if value == 0.0 || value >= current_food:
		eated.emit(current_food + value, current_food)
		current_food = 0.0
		_food_depleted()
		return current_food
	else:
		current_food -= value
		eated.emit(current_food + value, current_food)
		return value


func is_eddible() -> bool:
	return current_food > 0


func add_food(amount: float) -> void:
	current_food += amount
	clamp(current_food, 0, max_food)


func _food_depleted() -> void:
	depleted.emit()
