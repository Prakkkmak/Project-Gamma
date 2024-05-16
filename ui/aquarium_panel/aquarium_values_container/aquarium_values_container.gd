class_name AquariumValuesContainer
extends HBoxContainer


@onready var oxygen_aquarium_value_display: AquariumValueDisplay = %OxygenAquariumValueDisplay


func set_oxygen(value: float) -> void:
	oxygen_aquarium_value_display.set_value(value)

