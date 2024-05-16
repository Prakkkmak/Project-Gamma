class_name AquariumPanel
extends PanelContainer

@onready var aquarium_values_container: AquariumValuesContainer = %AquariumValuesContainer
@onready var entities_happiness_container: EntitiesHappinessContainer = %EntitiesHappinessContainer
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


func track_entity(entity_info: EntityInfos) -> void:
	entities_happiness_container.track_entity(entity_info)


func update_happiness(entity_info: EntityInfos, happiness: HappinessStats) -> void:
	entities_happiness_container.update_happiness(entity_info, happiness)


func update_entity_count(entity_info: EntityInfos, count: int) -> void:
	entities_happiness_container.update_entity_count(entity_info, count)
