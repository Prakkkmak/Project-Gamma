class_name LivingInfos
extends EntityInfos


## Max healthpoints are the hp when spawned or fully healed
@export var max_health: int = 50

#region Conditions
@export var min_temperature: float = 80
@export var max_temperature: float = 120
@export var min_acidity: float = 80
@export var max_acidity: float = 120
@export var min_quality: float = 80
@export var max_quality: float = 120
@export var min_oxygen: int = 80
@export var max_oxygen: int = 120
#endregion


#region Grow
## Grow time in seconds
@export var grow_time: int = 20 

## Life span in secondes
@export var life_span: int = 60 * 10 # 10 minutes

## Start scale
@export var start_scale: float = 0.2
#endregion

func get_target_temperature() -> float:
	return ( max_temperature + min_temperature ) / 2


func get_target_acidity() -> float:
	return ( max_acidity + min_acidity ) / 2


func get_target_quality() -> float:
	return ( max_quality + min_quality ) / 2


func get_target_oxygen() -> float:
	return ( max_oxygen + min_oxygen ) / 2


func get_maximum_gap_temperature() -> float:
	return ( max_temperature - min_temperature ) / 2


func get_maximum_gap_acidity() -> float:
	return ( max_acidity - min_acidity ) / 2


func get_maximum_gap_quality() -> float:
	return ( max_quality - min_quality ) / 2


func get_maximum_gap_oxygen() -> float:
	return ( max_oxygen - min_oxygen ) / 2
