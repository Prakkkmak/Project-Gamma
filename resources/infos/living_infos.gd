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

## End scale
@export var end_scale: float = 1.0
#endregion

