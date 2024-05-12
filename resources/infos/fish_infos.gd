class_name FishInfos
extends LivingInfos

## Max Food represent the maximum food in the fish stomach
@export var max_food: int = 100

## Type of food the fish is looking
@export var food_regimes: Array[Enums.FoodType] = [Enums.FoodType.VEGETABLE]

## Food Threshold is the number where the fish start to search for food
@export var food_threshold: int = 20

## Max Speed
@export var max_speed: float = 10.0

## Acceleration
@export var acceleration: float = 1.0

## Start scale
@export var start_scale: float = 0.2

## End scale
@export var end_scale: float = 1.0

## Texture
@export var texture: Texture
