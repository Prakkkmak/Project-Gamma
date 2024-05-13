class_name Card
extends TextureRect

signal used
signal dragged(is_dragged: bool)
signal discarded

@export var entity_infos: EntityInfos

@onready var use_button: Button = %UseButton
@onready var discard_button: Button = %DiscardButton
@onready var name_label: Label = %NameLabel
@onready var texture_rect: TextureRect = %TextureRect


var base_position: Vector2 = Vector2.ZERO
var selection_position_offset: float = 10.0
var drag_position: Vector2 = Vector2.ZERO
var drag_enabled: bool = false
var disable_mouse_features: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = entity_infos.display_name
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


func _process(delta: float) -> void:
	if drag_enabled:
		global_position = get_global_mouse_position() + drag_position


func _on_mouse_entered() -> void:
	if disable_mouse_features:
		return
	if !drag_enabled:
		base_position = global_position
	global_position = global_position + Vector2.UP * selection_position_offset


func _on_mouse_exited() -> void:
	if disable_mouse_features:
		return
	global_position = base_position


func _on_gui_input(event: InputEvent) -> void:
	if disable_mouse_features && !drag_enabled:
		return
	if (event is InputEventMouseButton):
		if event.is_action_pressed("click"):
			drag_position = global_position - get_global_mouse_position()
			drag_enabled = true
			dragged.emit(drag_enabled)
			z_index = 1
		if event.is_action_released("click"):
			drag_enabled = false
			global_position = base_position
			dragged.emit(drag_enabled)
			z_index = 0

