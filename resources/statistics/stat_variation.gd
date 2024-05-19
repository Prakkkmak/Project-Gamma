class_name StatVariation
extends Resource

@export var stat: Stat

@export var variation:float = 1.0

@export var maximum: float = 200.0

@export var minimum: float = 0.0


func get_variation() -> float:
	if stat.current_value + variation > maximum:
		return maximum - stat.current_value
	elif  stat.current_value + variation < minimum:
		return minimum - stat.current_value
	else:
		return variation
