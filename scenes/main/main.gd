class_name Main
extends Node

@export var stats: Array[Stat] = []

@export var simulation_speed: float = 1.0
@export var decks: Array[Deck] = []
@export var starting_cards: Array[EntityInfos] = []

@onready var aquarium: Aquarium = %Aquarium
@onready var debug_panel: DebugPanel = $CanvasLayer/DebugPanel
@onready var oxygen_constant_display: ConstantDisplay = %OxygenConstantDisplay
@onready var card_selection_panel: CardSelectionPanel = %CardSelectionPanel

@onready var hand_panel: HandPanel = %HandPanel

@onready var aquarium_panel: AquariumPanel = %AquariumPanel
@onready var shop_button: TextureButton = %ShopButton
@onready var shop: Shop = %Shop
@onready var money_label: Label = %MoneyLabel


var money: float = 20

func _ready() -> void:
	aquarium.stats = stats
	for stat in stats:
		aquarium_panel.track_new_stat(stat)
	Engine.time_scale = simulation_speed
	hand_panel.card_used.connect(_on_card_used)
	shop_button.pressed.connect(_on_shop_button_pressed)
	aquarium.income_perseved.connect(_on_income_perseved)
	aquarium.happiness_updated.connect(_on_happiness_updated)
	aquarium.count_updated.connect(_on_count_updated)
	card_selection_panel.entities_selected.connect(_on_entities_selected)
	shop.set_decks(decks)
	shop.closed.connect(_on_shop_closed)
	shop.booster_purshased.connect(_on_booster_purshased)
	for deck: Deck in decks:
		deck.generate()
		shop.unlock_booster(deck)
		for info: EntityInfos in deck.elements:
			aquarium_panel.track_entity(info)
	for starting_card: EntityInfos in starting_cards:
		hand_panel.add_card(starting_card)


func open_booster(deck: Deck) -> void:
	money -= deck.price
	aquarium_panel.set_money(money)
	var entities: Array[EntityInfos] = deck.draw()
	card_selection_panel.show()
	card_selection_panel.display_selection(entities, deck.max_choices)


func _on_card_drag(entity_infos: EntityInfos, use_position: Vector2) -> void:
	use_position = aquarium.get_global_mouse_position()
	if entity_infos is PlantInfos:
		var plant_infos: PlantInfos = entity_infos as PlantInfos
		aquarium.preview_plant(plant_infos, use_position)

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


func _on_shop_button_pressed() -> void:
	shop.show()


func _on_income_perseved(value: float) -> void:
	money += value
	aquarium_panel.set_money(money)


func _on_happiness_updated(entity_infos: EntityInfos, hapiness: HappinessStats) -> void:
	aquarium_panel.update_happiness(entity_infos, hapiness)


func _on_count_updated(entity_infos: EntityInfos, count: int) -> void:
	aquarium_panel.update_entity_count(entity_infos, count)


func _on_entities_selected(entities_infos: Array[EntityInfos]) -> void:
	for entity_infos: EntityInfos in entities_infos:
		hand_panel.add_card(entity_infos)
	card_selection_panel.hide()


func _on_shop_closed() -> void:
	shop.hide()

func _on_booster_purshased(deck: Deck) -> void:
	shop.hide()
	open_booster(deck)
