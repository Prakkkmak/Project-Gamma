class_name HandPanel 
extends Control

enum DropZone {NORMAL, USE, DISCARD}

signal card_used(entity_info: EntityInfos, position: Vector2)
signal card_discarded(entity_info: EntityInfos)
signal card_start_dragged(entity_infos: EntityInfos)
signal card_dragged(entity_infos: EntityInfos)
signal card_stop_dragged()

@export var card_scene: PackedScene
@export var max_hand_size: int = 8

@onready var cards_container: HBoxContainer = %CardsContainer
@onready var use_area: ColorRect = %UseArea
@onready var discard_area: TextureRect = %DiscardArea

@onready var card_used_audio_stream_player: AudioStreamPlayer = %CardUsedAudioStreamPlayer
@onready var discard_audio_stream_player: AudioStreamPlayer = %DiscardAudioStreamPlayer
@onready var card_drag_audio_stream_player: AudioStreamPlayer = %CardDragAudioStreamPlayer



var hand_cards: Array[Card] = []


func _ready() -> void:
	discard_area.self_modulate = Color.TRANSPARENT

func add_card(entity_info: EntityInfos) -> void:
	if entity_info == null:
		return
	var card: Card = card_scene.instantiate()
	card.drag_started.connect(_on_card_drag_started.bind(card))
	card.drag.connect(_on_drag.bind(card))
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
	discard_area.self_modulate = Color.WHITE
	for hand_card: Card in hand_cards:
		hand_card.selectable = false
	card_drag_audio_stream_player.play()


func _on_drag(card: Card) -> void:
	card_dragged.emit(card.entity_infos)

func _on_card_drag_stopped(drop_position: Vector2, card: Card) -> void:
	discard_area.self_modulate = Color.TRANSPARENT
	for hand_card: Card in hand_cards:
		hand_card.selectable = true
	var drop_zone: DropZone = _get_drop_zone(drop_position)
	if drop_zone == DropZone.USE:
		card_used.emit(card.entity_infos, drop_position)
		card_used_audio_stream_player.play()
		delete_card(hand_cards.find(card))
	elif drop_zone == DropZone.DISCARD:
		delete_card(hand_cards.find(card))
		discard_audio_stream_player.play()
		card_discarded.emit(card.entity_infos)
	else:
		card.reset_position()
	card_stop_dragged.emit()
