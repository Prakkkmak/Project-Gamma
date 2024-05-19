class_name AquariumStatsGrid
extends HBoxContainer


@export var aquarium_stat_column_scene: PackedScene
@export var tracked_stats: Array[Stat]
@export var living_infos: LivingInfos

func fill() -> void:
	for tracked_stat in tracked_stats:
		var aquarium_stat_column: AquariumStatColumn = aquarium_stat_column_scene.instantiate()
		aquarium_stat_column.stat = tracked_stat
		aquarium_stat_column.living_infos = living_infos
		add_child(aquarium_stat_column)
		aquarium_stat_column.fill()
