class_name CardSelectionPanel
extends PanelContainer


signal entities_selected(entities_infos: Array[EntityInfos])
signal rerolled

@export var default_selection: Array[EntityInfos] = []
@export var card_scene: PackedScene

@onready var reroll_button: Button = %RerollButton
@onready var validate_button: TextureButton = %ValidateButton

@onready var cards_display: HBoxContainer = %CardsDisplay
@onready var pick_instruction_label: Label = $CenterContainer/VBoxContainer/PickInstructionLabel


var cards: Array[Card] = []
var current_cards_selected: Array[Card] = []
var selectable_amount: int = 0

func _ready() -> void:
	validate_button.pressed.connect(_on_validate_button_pressed)
	reroll_button.pressed.connect(_on_reroll_button_pressed)


func disable_reroll(value: bool) -> void:
	reroll_button.disabled = value

func display_selection(entities_infos: Array[EntityInfos], new_selectable_amount: int) -> void:
	cards = []
	current_cards_selected = []
	for n in cards_display.get_children():
		n.queue_free()
	for entity_infos in entities_infos:
		var card: Card = card_scene.instantiate()
		card.entity_infos = entity_infos
		cards_display.add_child(card)
		cards.append(card)
		card.selectable = false
		card.gui_input.connect(_on_card_gui_input.bind(card))
		card.mouse_entered.connect(_on_mouse_entered.bind(card))
		card.mouse_exited.connect(_on_mouse_exited.bind(card))
	pick_instruction_label.text = "Pick " + str(new_selectable_amount) + " cards !"
	selectable_amount = new_selectable_amount


func cards_remaining() -> int:
	return selectable_amount - current_cards_selected.size()


func _on_card_gui_input(event: InputEvent, card: Card) -> void:
	if (event is InputEventMouseButton):
		if event.is_action_pressed("click"):
			if current_cards_selected.find(card) == -1 && cards_remaining() > 0:
				card.animation_player.play("select")
				current_cards_selected.append(card)
			elif  current_cards_selected.find(card) >= 0:
				card.animation_player.play("unselect")
				current_cards_selected.erase(card)


func _on_mouse_entered(card: Card) -> void:
	if current_cards_selected.find(card) == -1 && cards_remaining() > 0:
		card.animation_player.play("hover")


func _on_mouse_exited(card: Card) -> void:
	if current_cards_selected.find(card) == -1 && cards_remaining() > 0  && card.animation_player.current_animation == "hover":
		card.animation_player.stop()


func _on_validate_button_pressed() -> void:
	var entities: Array[EntityInfos] = []
	for current_card_selected: Card in current_cards_selected:
		entities.append(current_card_selected.entity_infos)
	entities_selected.emit(entities)

func _on_reroll_button_pressed() -> void:
	rerolled.emit()
