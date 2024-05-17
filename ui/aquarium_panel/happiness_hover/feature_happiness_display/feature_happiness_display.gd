class_name FeatureHappinessDisplay
extends HBoxContainer

@onready var feature_name: Label = %FeatureName
@onready var feature_values: Label = %FeatureValues
@onready var progress_bar: ProgressBar = %ProgressBar


func set_display_name(display_name: String) -> void:
	feature_name.text = display_name


func set_values(minimal_value: float, maximal_value: float = 0) -> void:
	feature_values.text = str(minimal_value) + "-" + str(maximal_value)


func set_happiness_value(val: float) -> void:
	progress_bar.value = val
