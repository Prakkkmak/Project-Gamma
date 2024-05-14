class_name Main
extends Node

@export var fish_infos: Array[FishInfos] = []
@export var plant_infos: Array[PlantInfos] = []

@onready var aquarium: Aquarium = %Aquarium
@onready var debug_panel: DebugPanel = $CanvasLayer/DebugPanel

@onready var hand_panel: HandPanel = %HandPanel
@onready var draw_card_button: Button = %DrawCardButton

@onready var money_label: Label = %MoneyLabel

var money: float = 20

func _ready() -> void:
	debug_panel.spawn_fish_requested.connect(_on_spawn_fish_requested)
	debug_panel.spawn_plant_requested.connect(_on_spawn_plant_requested)
	debug_panel.spawn_food_requested.connect(_on_spawn_food_requested)
	hand_panel.card_used.connect(_on_card_used)
	draw_card_button.pressed.connect(_on_draw_card_button_pressed)
	aquarium.income_perseved.connect(_on_income_perseved)


func _on_spawn_fish_requested(variant: int) -> void:
	var selected_fish_infos: FishInfos = fish_infos[variant - 1]
	aquarium.add_fish(selected_fish_infos)


func _on_spawn_plant_requested(variant: int) -> void:
	var selected_plant_infos: PlantInfos = plant_infos[variant - 1]
	aquarium.add_plant(selected_plant_infos)
	

func _on_spawn_food_requested(variant: int) -> void:
	var pos: Vector2 = Vector2(randi_range(-400,400),-200)
	aquarium.add_food(pos)


func _on_card_used(entity_infos: EntityInfos, use_position: Vector2) -> void:
	use_position = aquarium.get_global_mouse_position()
	if entity_infos is FishInfos:
		var fish_infos: FishInfos = entity_infos as FishInfos
		aquarium.add_fish(fish_infos, use_position)
	if entity_infos is PlantInfos:
		var plant_infos: PlantInfos = entity_infos as PlantInfos
		aquarium.add_plant(plant_infos, use_position)

func _on_draw_card_button_pressed() -> void:
	money -= 10
	var all_cards: Array[EntityInfos] = []
	all_cards.append_array(fish_infos)
	all_cards.append_array(plant_infos)
	hand_panel.add_card(all_cards.pick_random() as EntityInfos)
	hand_panel.add_card(all_cards.pick_random() as EntityInfos)
	hand_panel.add_card(all_cards.pick_random() as EntityInfos)

func _on_income_perseved(value: float) -> void:
	money += value
	money_label.text = str(ceil(money))
