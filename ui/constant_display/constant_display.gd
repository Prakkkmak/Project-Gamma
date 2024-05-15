class_name ConstantDisplay
extends PanelContainer

@export var constant_name: StringName

@onready var constant_label: Label = %ConstantLabel
@onready var negative_progress_bar: ProgressBar = %NegativeProgressBar
@onready var positive_progress_bar: ProgressBar = %PositiveProgressBar



func _ready() -> void:
	constant_label.text = constant_name


func update_constant(new_value: int) -> void:
	negative_progress_bar.value = -new_value
	positive_progress_bar.value = new_value
