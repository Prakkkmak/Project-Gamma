class_name AquariumValueDisplay
extends VBoxContainer

@export_category("Starting Values")
@export var display_name: String = ""
@export var starting_value: float = 100.0

@export_category("Thresholds")
@export var stable_value: float = 100.0
@export var stable_color: Color = Color.WHITE
@export var stable_delta: float = 10.0
@export var critical_delta: float = 20.0
@export var critical_color: Color = Color.RED


@onready var display_name_label: Label = %DisplayNameLabel
@onready var value_label: Label = %ValueLabel

func _ready() -> void:
	set_display_name(display_name)
	set_value(starting_value)

func set_display_name(displa_name: String) -> void:
	display_name_label.text = displa_name


func set_value(value: float) -> void:
	value_label.text = str(value) + " %"
	_update_critical_color(value)


func _update_critical_color(value: float) -> void:
	var delta: float = abs(value - stable_value)
	var delta_ratio: float = clamp((delta - stable_delta) / (critical_delta - stable_delta), 0.0, 1.0)
	value_label.modulate = lerp(stable_color, critical_color, delta_ratio)
