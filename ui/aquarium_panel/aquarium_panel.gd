class_name AquariumPanel
extends PanelContainer

@onready var aquarium_values_container: AquariumValuesContainer = %AquariumValuesContainer
@onready var entities_rows_container: VBoxContainer = %EntitiesRowsContainer
@onready var money_value_container: MoneyValueContainer = %MoneyValueContainer

func _ready() -> void:
	set_oxygen(12)
	set_money(40)
	set_money_variation(+4)


func set_oxygen(value: float) -> void:
	aquarium_values_container.set_oxygen(value)


func set_money(value: float) -> void:
	money_value_container.set_money(value)


func set_money_variation(value: float) -> void:
	money_value_container.set_variation(value)
