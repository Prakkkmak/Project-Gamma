class_name LivingInfos
extends EntityInfos


## Max healthpoints are the hp when spawned or fully healed
@export var max_health: int = 50

#region Conditions
@export var stats_requirements: Array[StatRequirement] = []
#endregion


func get_stat_requirements(stat: Stat) -> StatRequirement:
	for stat_requirement in stats_requirements:
		if stat_requirement.stat == stat:
			return stat_requirement
	return null
