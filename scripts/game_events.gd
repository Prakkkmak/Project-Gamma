extends Node

signal deck_unlocked(deck: Deck)
signal stat_updated(stat: Stat, value: float, aquarium: Aquarium)


func unlock_deck(deck: Deck) -> void:
	deck_unlocked.emit(name)


func update_stat(stat:Stat, value: float, aquarium: Aquarium) -> void:
	stat_updated.emit(stat, value, aquarium)
