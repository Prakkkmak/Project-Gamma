class_name StatRequirement
extends Resource

@export var stat: Stat

@export var maximum:float = 200.0

@export var target: float = 100.0

@export var minimum: float = 0.0


func get_gap() -> float:
	return ( maximum - minimum ) / 2


func get_outside_requirement_delta() -> float:
	if stat.current_value < minimum:
		return minimum - stat.current_value
	elif stat.current_value > maximum:
		return stat.current_value  - maximum
	return 0.0
