class_name Plant
extends Node2D



@export var food_component_scene: PackedScene

@onready var food_components_node: Node2D = %FoodComponentsNode
@onready var sprite: Sprite2D = %Sprite

var infos: PlantInfos
var food_components: Array[FoodComponent] = []


func _ready() -> void:
	assert(food_component_scene && infos)
	if !food_component_scene || !infos:
		return
	sprite.texture = infos.texture
	scale *= infos.end_scale
	var texture_size: float = sprite.texture.get_height() * infos.end_scale / 2
	print(texture_size)
	print(sprite.offset)
	sprite.offset = Vector2(sprite.offset.x, -texture_size)
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
