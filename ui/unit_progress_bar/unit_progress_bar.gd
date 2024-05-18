@tool
extends Control

@export var progress: Texture

@export var under: Texture

@export var value: float = 0.0

@export var min: float = 0.0

@export var max: float = 100.0

@export var unit_amount: int = 10

@export var offset: float = 0.0

@export var texture_size: float = 16.0

func _ready() -> void:
	custom_minimum_size = Vector2(texture_size + ((texture_size - offset) * (unit_amount - 1)), texture_size)
	for i in range(unit_amount - 1, - 1, -1):
		var texture_rect: TextureRect = TextureRect.new()
		add_child(texture_rect)
		texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH
		texture_rect.size = Vector2.ONE * texture_size
		texture_rect.position = Vector2.RIGHT * i * texture_size
		texture_rect.position += Vector2.LEFT * offset *  i
		print(texture_rect.position)
	set_value(value)


func set_value(value: float) -> void:
	var number_of_units: int = floor(value / (max / unit_amount))
	var i: int = unit_amount
	for texture_rect: TextureRect in get_children():
		if i <= number_of_units:
			texture_rect.texture = progress
		else:
			texture_rect.texture = under
		i -= 1
