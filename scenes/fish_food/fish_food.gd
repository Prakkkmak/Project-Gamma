class_name FishFood
extends RigidBody2D

@onready var food_amount_label: Label = %FoodAmountLabel
@onready var food_component: FoodComponent = %FoodComponent

var infos: FoodInfos

func _ready() -> void:
	if !infos :
		return
	food_component.depleted.connect(_on_food_component_depleted)
	food_component.eated.connect(_on_food_component_eated)
	food_component.max_food = infos.food_amount
	food_component.current_food = infos.food_amount
	food_component.sprite.texture = infos.texture
	food_component.sprite.scale *= infos.scale
	food_component.sprite.scale *= infos.scale


func _on_food_component_depleted() -> void:
	queue_free()

func _on_food_component_eated(old_amount: float, new_amount: float) -> void:
	linear_velocity = Vector2.ZERO
	food_amount_label.text = str(new_amount)
