class_name Plant
extends Node2D



@export var food_component_scene: PackedScene

@onready var food_components_node: Node2D = %FoodComponentsNode
@onready var sprite: Sprite2D = %Sprite

var current_health: float = 0.0

var infos: PlantInfos
var food_components: Array[FoodComponent] = []

var aquarium: Aquarium

func _ready() -> void:
	assert(food_component_scene && infos)
	if !food_component_scene || !infos:
		return
	sprite.texture = infos.texture
	scale *= infos.scale
	var texture_size: float = sprite.texture.get_height() * infos.scale / 2
	sprite.offset = Vector2(sprite.offset.x, -texture_size)
	current_health = infos.max_health
	for position: Vector2 in infos.food_positions:
		var food_component: FoodComponent = food_component_scene.instantiate()
		food_component.max_food = infos.total_food / infos.food_positions.size()
		food_component.eddible = false
		food_components_node.add_child(food_component)
		food_component.position = position
		food_component.current_food = 0.0
		food_components.append(food_component)


func _process(delta: float) -> void:
	for food_component: FoodComponent in food_components:
		food_component.add_food(delta * infos.grow_speed)
	for stat_requirement: StatRequirement in infos.stats_requirements:
		var condition_delta: float = abs(stat_requirement.get_outside_requirement_delta())
		if condition_delta > 0:
			take_damage(condition_delta)

func take_damage(amount: float) -> void:
	current_health -= amount
	if current_health < 0:
		_die()

func _die() -> void:
	queue_free()
