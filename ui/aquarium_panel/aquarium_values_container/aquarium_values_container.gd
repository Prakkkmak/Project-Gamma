class_name AquariumValuesContainer
extends HBoxContainer


@onready var oxygen_aquarium_value_display: AquariumValueDisplay = %OxygenAquariumValueDisplay
@onready var quality_aquarium_value_display: AquariumValueDisplay = %QualityAquariumValueDisplay


func set_oxygen(value: float) -> void:
	oxygen_aquarium_value_display.set_value(value)


func set_quality(value: float) -> void:
	quality_aquarium_value_display.set_value(value)
