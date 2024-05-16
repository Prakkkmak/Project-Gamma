class_name MoneyValueContainer
extends VBoxContainer

@onready var money_label: Label = %MoneyLabel
@onready var money_variation_label: Label = %MoneyVariationLabel


func set_money(value: float) -> void:
	money_label.text = str(floor(value)) + "$"


func set_variation(value: float) -> void:
	money_variation_label.text = "+" + str(floor(value))
