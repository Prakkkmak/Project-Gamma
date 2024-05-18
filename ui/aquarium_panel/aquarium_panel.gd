class_name AquariumPanel
extends PanelContainer

@onready var aquarium_values_container: AquariumValuesContainer = %AquariumValuesContainer
@onready var entities_happiness_container: EntitiesHappinessContainer = %EntitiesHappinessContainer
@onready var money_value_container: MoneyValueContainer = %MoneyValueContainer
@onready var happiness_hover: HappinessHover = $GridContainer/HappinessHover

func _ready() -> void:
	entities_happiness_container.entity_happiness_view_mouse_entered.connect(_on_entity_happiness_view_mouse_entered)
	entities_happiness_container.entity_happiness_view_mouse_exited.connect(_on_entity_happiness_view_mouse_exited)



func _process(delta: float) -> void:
	aquarium_values_container.update_aquarium_value_displays()

func track_new_stat(stat: Stat) -> void:
	aquarium_values_container.track_new_stat(stat)

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


func _on_entity_happiness_view_mouse_entered(entity_info: EntityInfos, happiness_stats: HappinessStats) -> void:
	happiness_hover.show()
	happiness_hover.fill_infos(entity_info, happiness_stats)


func _on_entity_happiness_view_mouse_exited(entity_info: EntityInfos) -> void:
	happiness_hover.hide()
