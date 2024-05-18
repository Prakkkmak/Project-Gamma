class_name AquariumValueDisplay
extends VBoxContainer

@export_category("Stat")
@export var stat: Stat


@export_category("Thresholds colors")
@export var stable_color: Color = Color.WHITE
@export var critical_color: Color = Color.RED



@onready var display_name_label: Label = %DisplayNameLabel
@onready var value_label: Label = %ValueLabel



func _ready() -> void:
	set_display_name(stat.display_name)
	set_value(stat.current_value)


func update_display() -> void:
	set_value(stat.current_value)


func set_display_name(displa_name: String) -> void:
	display_name_label.text = displa_name


func set_value(value: float) -> void:
	value_label.text = str(floor(value)) + " %"
	_update_critical_color(value)


func _update_critical_color(value: float) -> void:
	var delta: float = abs(value - stat.neutral_value)
	var delta_ratio: float = clamp((delta - stat.stable_delta) / (stat.critical_delta - stat.stable_delta), 0.0, 1.0)
	value_label.modulate = lerp(stable_color, critical_color, delta_ratio)
