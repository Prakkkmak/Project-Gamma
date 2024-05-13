class_name LivingInfos
extends EntityInfos


## Max healthpoints are the hp when spawned or fully healed
@export var max_health: int = 50

#region Conditions
## Minimal temperature in °C included in range -100-100 
@export var min_temperature: int = 22
## Maximum temperature in °C excluded in range -100-100 
@export var max_temperature: int = 26

## Minimal pH included in range 0-14
@export var min_acidity: int = 6
## Maximum ph excluded in range 0-14
@export var max_acidity: int = 8 

## Lower sanity level, under this level the entity can't survive
@export var min_quality: int = 50

## Min oxygen
@export var min_oxygen_saturation: int = 90

## Max oxygen
@export var max_oxygen_saturation: int = 110
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


## Texture
@export var texture: Texture
