class_name FishFood
extends RigidBody2D

@onready var food_amount_label: Label = %FoodAmountLabel
@onready var food_component: FoodComponent = %FoodComponent
@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	food_component.depleted.connect(_on_food_component_depleted)
	food_component.eated.connect(_on_food_component_eated)


func _on_food_component_depleted() -> void:
	queue_free()

func _on_food_component_eated(old_amount: float, new_amount: float) -> void:
	linear_velocity = Vector2.ZERO
	food_amount_label.text = str(new_amount)
