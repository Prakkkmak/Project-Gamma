class_name FoodComponent
extends Node2D


signal depleted
signal eddible_changed(is_eddible: bool)
signal eated(old_amount: float, new_amount: float)


## Used for the particules and scaling
@export var food_sprite: Sprite2D
## Particles
@export var gpu_particles_2d: GPUParticles2D

@export var food_type: Enums.FoodType = Enums.FoodType.VEGETABLE
@export var max_food: float = 10.0


@onready var current_food: float = max_food


var _currently_eating: int = 0
var eddible: bool = true


func _ready() -> void:
	if gpu_particles_2d && food_sprite:
		gpu_particles_2d.texture = food_sprite.texture


func start_eating() -> void:
	_currently_eating += 1
	if gpu_particles_2d:
		gpu_particles_2d.emitting = true


func stop_eating() -> void:
	_currently_eating -= 1
	if _currently_eating < 1:
		if gpu_particles_2d:
			gpu_particles_2d.emitting = false


func is_eatting() -> bool:
	return _currently_eating > 0

func is_eddible() -> bool:
	return eddible


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


func add_food(amount: float) -> void:
	current_food += amount
	if current_food >= max_food:
		current_food = max_food
		eddible = true
		eddible_changed.emit(true)

func _food_depleted() -> void:
	eddible = false
	eddible_changed.emit(false)
	depleted.emit()
