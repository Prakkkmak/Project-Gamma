class_name Booster
extends VBoxContainer

signal selected

@export var deck: Deck

@onready var booster_texture_button: TextureButton = %BoosterTexture

@onready var price_label: Label = %PriceLabel

@onready var gold_icon: TextureRect = %GoldIcon


func _ready() -> void:
	booster_texture_button.texture_normal = deck.texture
	price_label.text =  str(deck.price)
	booster_texture_button.pressed.connect(_on_booster_texture_button_pressed)
	disable()

func unlock() -> void:
	enable()

func enable() -> void:
	booster_texture_button.modulate = Color.WHITE
	booster_texture_button.disabled = false


func disable() -> void:
	booster_texture_button.modulate = lerp(Color.WHITE, Color.BLACK, 0.8)
	booster_texture_button.disabled = true


func _on_booster_texture_button_pressed() -> void:
	selected.emit()
