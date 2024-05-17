class_name EntitiesHappinessContainer
extends VBoxContainer

signal entity_happiness_view_mouse_entered(entity_info: EntityInfos, happiness_stats: HappinessStats)
signal entity_happiness_view_mouse_exited(entity_info: EntityInfos)

@export var entity_happiness_view_scene: PackedScene

@onready var fishs_happiness: HBoxContainer = %FishsHappiness
@onready var plants_happiness: HBoxContainer = %PlantsHappiness


var tracked_entities: Dictionary


func track_entity(entity_info: EntityInfos) -> void:
	if !(entity_info is FishInfos) && !(entity_info is PlantInfos):
		return
	var entity_happiness_view: EntityHappinessView = entity_happiness_view_scene.instantiate()
	entity_happiness_view.infos = entity_info
	tracked_entities[entity_info] = entity_happiness_view
	if entity_info is FishInfos:
		fishs_happiness.add_child(entity_happiness_view)
	elif entity_info is PlantInfos:
		plants_happiness.add_child(entity_happiness_view)
	entity_happiness_view.mouse_entered.connect(_on_entity_happiness_view_mouse_entered.bind(entity_happiness_view))
	entity_happiness_view.mouse_exited.connect(_on_entity_happiness_view_mouse_exited.bind(entity_happiness_view))


func update_happiness(entity_info: EntityInfos, happiness: HappinessStats) -> void:
	if tracked_entities.has(entity_info) && tracked_entities[entity_info] is EntityHappinessView:
		var tracked_entity: EntityHappinessView = tracked_entities[entity_info]
		tracked_entity.set_happiness(happiness)


func update_entity_count(entity_info: EntityInfos, count: int) -> void:
	if tracked_entities.has(entity_info) && tracked_entities[entity_info] is EntityHappinessView:
		var tracked_entity: EntityHappinessView = tracked_entities[entity_info]
		tracked_entity.set_count(count)


func _on_entity_happiness_view_mouse_entered(entity_happiness_view: EntityHappinessView) -> void:
	if !entity_happiness_view.current_happiness:
		return
	entity_happiness_view_mouse_entered.emit(entity_happiness_view.infos, entity_happiness_view.current_happiness)


func _on_entity_happiness_view_mouse_exited(entity_happiness_view: EntityHappinessView) -> void:
	print("bb")
	entity_happiness_view_mouse_exited.emit(entity_happiness_view.infos)
