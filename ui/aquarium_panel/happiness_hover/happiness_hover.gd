class_name HappinessHover
extends PanelContainer


@export var feature_happiness_display_scene: PackedScene

@onready var entity_display_name_label: Label = $VBoxContainer/EntityDisplayNameLabel
@onready var features_container: VBoxContainer = %FeaturesContainer


func fill_infos(entity_infos: EntityInfos, happiness: HappinessStats) -> void:
	entity_display_name_label.text = entity_infos.display_name
	var happiness_features: Dictionary = happiness.get_happiness_features()
	for features_container in features_container.get_children():
		features_container.queue_free()
	for happiness_key: String in happiness_features:
		var feature_happiness_display: FeatureHappinessDisplay = feature_happiness_display_scene.instantiate()
		features_container.add_child(feature_happiness_display)
		var value: float = happiness_features[happiness_key]
		var display_feature_name: String = happiness_key
		if display_feature_name:
			feature_happiness_display.set_display_name(display_feature_name)
		feature_happiness_display.set_happiness_value(value)
