class_name EntityInfos
extends Resource


enum Rarity { INVALID, D, C, B, A, S }


## Display name of the entity
@export var display_name: String = "-"

## Description of the entity
@export var description: String = "-"

## rarity
@export var rarity: Rarity = Rarity.D

## Price of the entity
@export var cost: int = 0

## Oxygen variation: positive value mean increase the oxygen while negative value mean remove
@export var oxygen_variation: float = 0.0

## Some stuff makes the temperature rise or cool
@export var temperature_variation: float = 0.0

## Some stuff makes the quality rise or cool
@export var quality_variation: float = 0.0

## Some stuff makes the temperature rise or cool
@export var acidity_variation: float = 0.0

@export var income_variation: float = 0.0

## Texture
@export var texture: Texture

## Texture
@export var texture_display: Texture

## End scale
@export var scale: float = 1.0


func get_texture_display() -> Texture:
	if texture_display:
		return texture_display
	else:
		return texture
