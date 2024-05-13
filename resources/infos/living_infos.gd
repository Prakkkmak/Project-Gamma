class_name LivingInfos
extends EntityInfos


## Max healthpoints are the hp when spawned or fully healed
@export var max_health: int = 50


## Minimal temperature in °C included in range -100-100 
@export var min_temperature: int = 22


## Maximum temperature in °C excluded in range -100-100 
@export var max_temperature: int = 26


## Minimal pH included in range 0-14
@export var min_ph: int = 6


## Maximum ph expluded in range 0-14
@export var max_ph: int = 8 


## Minimal luminosity included in range 0-100
@export var min_luminosity: int = 10


## Maximum luminosity excluded in range 0-100
@export var max_luminosity: int = 90


## Lower sanity level, under this level the entity can't survive
@export var min_sanity: int = 50


## Grow time in seconds
@export var grow_time: int = 20 


## Life span in secondes
@export var life_span: int = 60 * 10 # 10 minutes


## Start scale
@export var start_scale: float = 0.2


## End scale
@export var end_scale: float = 1.0


## Texture
@export var texture: Texture
