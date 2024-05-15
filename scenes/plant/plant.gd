class_name Plant
extends Node2D


@export var food_component_scene: PackedScene


@onready var food_slots: Node2D = %FoodSlots

var infos: PlantInfos
var food_components: Array[FoodComponent] = []


func _ready() -> void:
	assert(food_component_scene && infos)
	if !food_component_scene || !infos:
		return
	for node: Node2D in _pick_random_slots(infos.food_slots_amount):
		var food_component: FoodComponent = food_component_scene.instantiate()
		food_component.max_food = infos.total_food / infos.food_slots_amount
		food_component.eddible = false
		node.add_child(food_component)
		food_component.current_food = 0.0
		food_components.append(food_component)


func _process(delta: float) -> void:
	for food_component: FoodComponent in food_components:
		food_component.add_food(delta * GameConstants.speed * infos.grow_speed)


func _pick_random_slots(amount: int) -> Array[Node2D]:
	var selected_slots: Array[Node2D] = []
	var amount_remaining: int = amount
	var slots: Array[Node] = food_slots.get_children()
	while amount_remaining > 0 || slots.size() == 0:
		var slot: Node = slots.pick_random()
		slots.erase(slot)
		if !(slot is Node2D):
			continue
		selected_slots.append(slot as Node2D)
		amount_remaining -= 1
	return selected_slots
