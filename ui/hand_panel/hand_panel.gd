class_name HandPanel 
extends PanelContainer

signal card_used(entity_info: EntityInfos)
signal card_discarded(entity_info: EntityInfos)

@export var card_scene: PackedScene

@onready var cards_container: HBoxContainer = %CardsContainer

var hand_cards: Array[Card] = []

func _ready() -> void:
	add_card(EntityInfos.new())
	add_card(EntityInfos.new())
	add_card(EntityInfos.new())
	add_card(EntityInfos.new())
	add_card(EntityInfos.new())


func add_card(entity_info: EntityInfos) -> void:
	var card: Card = card_scene.instantiate()
	card.used.connect(_on_card_used.bind(card))
	card.discarded.connect(_on_card_discarded.bind(card))
	card.entity_infos = entity_info
	cards_container.add_child(card)
	card.name=str(hand_cards.size())
	hand_cards.append(card)


func add_cards(entity_infos: Array[EntityInfos]) -> void:
	for entity_info:EntityInfos in entity_infos:
		add_card(entity_info)


func delete_card(index: int) -> void:
	hand_cards[index].queue_free()
	hand_cards.remove_at(index)


func _on_card_discarded(card: Card) -> void:
	delete_card(hand_cards.find(card))
	card_discarded.emit(card.entity_infos)


func _on_card_used(card: Card) -> void:
	card_used.emit(card.entity_infos)
	delete_card(hand_cards.find(card))

