class_name Main
extends Node

@export var simulation_speed: float = 1.0
@export var decks: Array[Deck] = []
@export var starting_cards: Array[EntityInfos] = []

@onready var aquarium: Aquarium = %Aquarium
@onready var debug_panel: DebugPanel = $CanvasLayer/DebugPanel
@onready var oxygen_constant_display: ConstantDisplay = %OxygenConstantDisplay

@onready var hand_panel: HandPanel = %HandPanel
@onready var draw_card_button: TextureButton = %DrawCardButton
@onready var aquarium_panel: AquariumPanel = %AquariumPanel

@onready var money_label: Label = %MoneyLabel


var money: float = 20

func _ready() -> void:
	Engine.time_scale = simulation_speed
	hand_panel.card_used.connect(_on_card_used)
	draw_card_button.pressed.connect(_on_draw_card_button_pressed)
	aquarium.income_perseved.connect(_on_income_perseved)
	aquarium.happiness_updated.connect(_on_happiness_updated)
	aquarium.count_updated.connect(_on_count_updated)
	for deck: Deck in decks:
		deck.generate()
		for info: EntityInfos in deck.elements:
			aquarium_panel.track_entity(info)
	for starting_card: EntityInfos in starting_cards:
		hand_panel.add_card(starting_card)

func _process(delta: float) -> void:
	_update_draw_button()
	oxygen_constant_display.update_constant(aquarium.oxygen)
	_update_aquarium_pannel()

func _update_draw_button() -> void:
	draw_card_button.disabled = hand_panel.get_remaining_size() < 3 || money < 10


func _update_aquarium_pannel() -> void:
	#HACK Remove this in profit of signals
	aquarium_panel.set_oxygen(aquarium.oxygen)


func _on_card_used(entity_infos: EntityInfos, use_position: Vector2) -> void:
	use_position = aquarium.get_global_mouse_position()
	if entity_infos is FishInfos:
		var fish_infos: FishInfos = entity_infos as FishInfos
		aquarium.add_fish(fish_infos, use_position)
	if entity_infos is PlantInfos:
		var plant_infos: PlantInfos = entity_infos as PlantInfos
		aquarium.add_plant(plant_infos, use_position)
	if entity_infos is FoodInfos:
		var food_infos: FoodInfos = entity_infos as FoodInfos
		aquarium.add_food(food_infos, use_position)


func _on_draw_card_button_pressed() -> void:
	money -= 10
	aquarium_panel.set_money(money)
	var deck_selected: Deck = decks[0]
	hand_panel.add_card(deck_selected.pick_random_weighted() as EntityInfos)
	hand_panel.add_card(deck_selected.pick_random_weighted() as EntityInfos)
	hand_panel.add_card(deck_selected.pick_random_weighted() as EntityInfos)


func _on_income_perseved(value: float) -> void:
	money += value
	aquarium_panel.set_money(money)


func _on_happiness_updated(entity_infos: EntityInfos, hapiness: HappinessStats) -> void:
	aquarium_panel.update_happiness(entity_infos, hapiness)


func _on_count_updated(entity_infos: EntityInfos, count: int) -> void:
	aquarium_panel.update_entity_count(entity_infos, count)
