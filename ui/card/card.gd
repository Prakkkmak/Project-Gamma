class_name Card
extends TextureRect


signal selected
signal unselected
signal drag_started
signal drag_stopped(drop_position: Vector2)


@export var entity_infos: EntityInfos
@export var usage_area_rect: Rect2

@onready var use_button: Button = %UseButton
@onready var discard_button: Button = %DiscardButton

@onready var name_label: Label = %NameLabel
@onready var entity_texture: TextureRect = %EntityTexture


@onready var animation_player: AnimationPlayer = $AnimationPlayer


var base_position: Vector2 = Vector2.ZERO
var selection_position_offset: float = 100.0
var drag_position: Vector2 = Vector2.ZERO
var drag_enabled: bool = false
var selectable: bool = true


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fill_infos()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


func reset_position() -> void:
	global_position = base_position


func _fill_infos() -> void:
	name_label.text = entity_infos.display_name
	entity_texture.texture = entity_infos.get_texture_display()



func _process(delta: float) -> void:
	if drag_enabled:
		global_position = get_global_mouse_position() + drag_position


func _on_mouse_entered() -> void:
	if !selectable:
		return
	if !drag_enabled:
		base_position = global_position
	global_position = global_position + Vector2.UP * selection_position_offset


func _on_mouse_exited() -> void:
	if !selectable:
		return
	reset_position()


func _on_gui_input(event: InputEvent) -> void:
	if !selectable && !drag_enabled:
		return
	if (event is InputEventMouseButton):
		if event.is_action_pressed("click"):
			drag_position = global_position - get_global_mouse_position()
			drag_enabled = true
			drag_started.emit()
			z_index = 1
		if event.is_action_released("click"):
			drag_enabled = false
			#Check here if area for deletion and check if the drop is in good position
			z_index = 0
			drag_stopped.emit(get_global_mouse_position())

