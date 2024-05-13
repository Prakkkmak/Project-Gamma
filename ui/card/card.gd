class_name Card
extends TextureRect

signal used
signal discarded

@export var entity_infos: EntityInfos

@onready var use_button: Button = %UseButton
@onready var discard_button: Button = %DiscardButton
@onready var name_label: Label = %NameLabel
@onready var card: Card = $"."

var zoom_scale:Vector2 = Vector2(1.2, 1.2)  
var original_scale:Vector2 = Vector2(1, 1) 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = entity_infos.display_name
	use_button.pressed.connect(_on_use_button_pressed)
	discard_button.pressed.connect(_on_discard_button_pressed)
	set_mouse_filter(MOUSE_FILTER_STOP)
	card.mouse_entered.connect(_on_mouse_entered)
	card.mouse_exited.connect(_on_mouse_exited)
	#pivot_offset.y = size.y
	


func _on_use_button_pressed() -> void:
	used.emit()


func _on_discard_button_pressed() -> void:
	discarded.emit()

func _on_mouse_entered() -> void:
	scale = zoom_scale
	z_index = 1


func _on_mouse_exited() -> void:
	scale = original_scale
	z_index = 0

