class_name EntityInfos
extends Resource


enum Rarity { INVALID, D, C, B, A, S }


## Display name of the entity
@export var display_name: String = "-"

## Description of the entity
@export_multiline var description: String

## rarity
@export var rarity: Rarity = Rarity.D

## Price of the entity
@export var cost: int = 0


@export var stats_variations: Array[StatVariation] = []


@export var income_variation: float = 0.0

## Texture
@export var texture: Texture

## Texture
@export var texture_display: Texture

## End scale
@export var scale: float = 1.0


func get_stat_variation(stat: Stat) -> StatVariation:
	for stat_variation in stats_variations:
		if stat_variation.stat == stat:
			return stat_variation
	return null


func get_texture_display() -> Texture:
	if texture_display:
		return texture_display
	else:
		return texture
