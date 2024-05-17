class_name FeatureHappinessDisplay
extends HBoxContainer

@onready var feature_name: Label = %FeatureName
@onready var progress_bar: ProgressBar = %ProgressBar


func set_display_name(display_name: String) -> void:
	feature_name.text = display_name



func set_happiness_value(val: float) -> void:
	progress_bar.value = val
