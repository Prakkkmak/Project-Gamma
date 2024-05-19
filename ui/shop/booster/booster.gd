class_name Booster
extends VBoxContainer

signal selected

@export var deck: Deck

@onready var booster_texture_button: TextureButton = %BoosterTexture

@onready var price_label: Label = %PriceLabel


func _ready() -> void:
	booster_texture_button.texture_normal = deck.texture
	price_label.text =  str(deck.price) + "$"
	booster_texture_button.pressed.connect(_on_booster_texture_button_pressed)
	disable()


func enable() -> void:
	booster_texture_button.modulate = Color.WHITE
	price_label.show()


func unlock() -> void:
	enable()


func disable() -> void:
	booster_texture_button.modulate = Color.BLACK
	price_label.hide()


func _on_booster_texture_button_pressed() -> void:
	selected.emit()
