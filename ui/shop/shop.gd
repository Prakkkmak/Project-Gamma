class_name Shop
extends PanelContainer

signal booster_purshased(deck: Deck)
signal closed



@export var booster_scene: PackedScene
@export var starting_decks: Array[Deck] = []
@export var boosters: Array[Booster] = []

@onready var close_button: Button = %CloseButton
@onready var boosters_grid: GridContainer = %Boosters


func _ready() -> void:
	set_decks(starting_decks)
	close_button.pressed.connect(_on_close_button_pressed)


func set_decks(new_decks: Array[Deck]) -> void:
	for booster in boosters:
		booster.queue_free()
	boosters = []
	for deck in new_decks:
		var booster: Booster = booster_scene.instantiate()
		booster.deck = deck
		boosters_grid.add_child(booster)
		boosters.append(booster)
		booster.selected.connect(_on_booster_selected.bind(deck))


func lock_by_money(money: float) -> void:
	for booster in boosters:
		if booster.deck.price > money:
			booster.disable()
		else:
			booster.enable()


func unlock_booster(deck: Deck) -> void:
	for booster: Booster in boosters:
		if booster.deck == deck:
			booster.unlock()


func _on_booster_selected(deck: Deck) -> void:
	booster_purshased.emit(deck)


func _on_close_button_pressed() -> void:
	closed.emit()
