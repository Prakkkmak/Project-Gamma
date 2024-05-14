class_name HandPanel 
extends Control

enum DropZone {NORMAL, USE, DISCARD}

signal card_used(entity_info: EntityInfos, position: Vector2)
signal card_discarded(entity_info: EntityInfos)

@export var card_scene: PackedScene
@export var max_hand_size: int = 8

@onready var cards_container: HBoxContainer = %CardsContainer
@onready var use_area: ColorRect = %UseArea
@onready var discard_area: ColorRect = %DiscardArea




var hand_cards: Array[Card] = []


func add_card(entity_info: EntityInfos) -> void:
	if entity_info == null:
		return
	var card: Card = card_scene.instantiate()
	card.drag_started.connect(_on_card_drag_started.bind(card))
	card.drag_stopped.connect(_on_card_drag_stopped.bind(card))
	card.entity_infos = entity_info
	cards_container.add_child(card)
	card.name = str(hand_cards.size())
	hand_cards.append(card)


func add_cards(entity_infos: Array[EntityInfos]) -> void:
	for entity_info:EntityInfos in entity_infos:
		add_card(entity_info)


func delete_card(index: int) -> void:
	hand_cards[index].queue_free()
	hand_cards.remove_at(index)


func get_remaining_size() -> int:
	return max_hand_size - hand_cards.size()


func _get_drop_zone(drop_position: Vector2) -> DropZone:
	if use_area.get_global_rect().has_point(drop_position):
		return DropZone.USE
	if discard_area.get_global_rect().has_point(drop_position):
		return DropZone.DISCARD
	return DropZone.NORMAL


func _on_card_drag_started(card: Card) -> void:
	for hand_card: Card in hand_cards:
		hand_card.selectable = false


func _on_card_drag_stopped(drop_position: Vector2, card: Card) -> void:
	for hand_card: Card in hand_cards:
		hand_card.selectable = true
	var drop_zone: DropZone = _get_drop_zone(drop_position)
	print(drop_zone)
	if drop_zone == DropZone.USE:
		card_used.emit(card.entity_infos, drop_position)
		delete_card(hand_cards.find(card))
	elif drop_zone == DropZone.DISCARD:
		delete_card(hand_cards.find(card))
		card_discarded.emit(card.entity_infos)
	else:
		card.reset_position()
