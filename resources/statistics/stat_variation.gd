class_name StatVariation
extends Resource

@export var stat: Stat

@export var variation:float = 1.0

@export var maximum: float = 120.0

@export var minimum: float = 80.0


func get_variation() -> float:
	if stat.current_value >= maximum || stat.current_value <= minimum:
		return 0.0
	else:
		return variation
