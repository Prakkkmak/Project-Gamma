class_name AquariumValuesContainer
extends HBoxContainer

@export var aquarium_value_display_scene: PackedScene

func track_new_stat(stat: Stat) -> void:
	var aquarium_value_display: AquariumValueDisplay = aquarium_value_display_scene.instantiate()
	aquarium_value_display.stat = stat
	add_child(aquarium_value_display)

func update_aquarium_value_displays() -> void:
	for n: Node in get_children():
		if n is AquariumValueDisplay:
			(n as AquariumValueDisplay).update_display()
