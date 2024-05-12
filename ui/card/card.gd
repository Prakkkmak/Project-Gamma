class_name Card
extends ColorRect

signal used
signal discarded

@export var entity_infos: EntityInfos

@onready var use_button: Button = %UseButton
@onready var discard_button: Button = %DiscardButton
@onready var name_label: Label = %NameLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	name_label.text = entity_infos.display_name
	use_button.pressed.connect(_on_use_button_pressed)
	discard_button.pressed.connect(_on_discard_button_pressed)


func _on_use_button_pressed() -> void:
	used.emit()


func _on_discard_button_pressed() -> void:
	discarded.emit()

