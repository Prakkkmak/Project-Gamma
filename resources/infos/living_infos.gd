class_name LivingInfos
extends EntityInfos


## Max healthpoints are the hp when spawned or fully healed
@export var max_health: int = 50

#region Conditions
@export var stats_requirements: Array[StatRequirement] = []
#endregion


#region Grow
## Grow time in seconds
@export var grow_time: int = 20 

## Life span in secondes
@export var life_span: int = 60 * 10 # 10 minutes

## Start scale
@export var start_scale: float = 0.2
#endregion

func get_stat_requirements(stat: Stat) -> StatRequirement:
	for stat_requirement in stats_requirements:
		if stat_requirement.stat == stat:
			return stat_requirement
	return null
