class_name FoodComponent
extends Node2D


signal depleted
signal eddible_changed(is_eddible: bool)
signal eated(old_amount: float, new_amount: float)


## Used for the particules and scaling
@export var food_sprite: Sprite2D


@export var food_type: Enums.FoodType = Enums.FoodType.VEGETABLE
@export var max_food: float = 10.0

@onready var gpu_particles_2d: GPUParticles2D = %GPUParticles2D

@onready var current_food: float = max_food
@onready var initial_sprite_scale: Vector2 = food_sprite.scale

var _currently_eating: int = 0
var eddible: bool = true


func _ready() -> void:
	if food_sprite:
		gpu_particles_2d.texture = food_sprite.texture


func start_eating() -> void:
	_currently_eating += 1
	gpu_particles_2d.emitting = true


func stop_eating() -> void:
	_currently_eating -= 1
	if _currently_eating < 1:
		gpu_particles_2d.emitting = false


func is_eatting() -> bool:
	return _currently_eating > 0

func is_eddible() -> bool:
	return eddible


func eat(value: float = 0.0) -> float:
	if value == 0.0 || value >= current_food:
		eated.emit(current_food + value, current_food)
		current_food = 0.0
		food_sprite.scale = initial_sprite_scale * current_food / max_food
		_food_depleted()
		return current_food
	else:
		current_food -= value
		eated.emit(current_food + value, current_food)
		food_sprite.scale = initial_sprite_scale * current_food / max_food
		return value


func add_food(amount: float, not_eddible_required: bool = true) -> void:
	if not_eddible_required && eddible:
		return
	current_food += amount
	food_sprite.scale = initial_sprite_scale * current_food / max_food
	if current_food >= max_food:
		current_food = max_food
		eddible = true
		eddible_changed.emit(true)

func _food_depleted() -> void:
	eddible = false
	eddible_changed.emit(false)
	depleted.emit()
