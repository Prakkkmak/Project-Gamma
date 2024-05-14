class_name Card
extends TextureRect

signal used
signal dragged(is_dragged: bool)
signal discarded

@export var entity_infos: EntityInfos

@onready var use_button: Button = %UseButton
@onready var discard_button: Button = %DiscardButton

@onready var name_label: Label = %NameLabel
@onready var entity_texture: TextureRect = %EntityTexture

@onready var temperature_condition_value_label: Label = %TemperatureConditionValueLabel
@onready var oxygen_condition_value_label: Label = %OxygenConditionValueLabel
@onready var quality_condition_value_label: Label = %QualityConditionValueLabel
@onready var acidity_condition_value_label: Label = %AcidityConditionValueLabel
@onready var temperature_condition_variation_label: Label = %TemperatureConditionVariationLabel
@onready var oxygen_condition_variation_label: Label = %OxygenConditionVariationLabel
@onready var quality_condition_variation_label: Label = %QualityConditionVariationLabel
@onready var acidity_condition_variation_label: Label = %AcidityConditionVariationLabel



var base_position: Vector2 = Vector2.ZERO
var selection_position_offset: float = 10.0
var drag_position: Vector2 = Vector2.ZERO
var drag_enabled: bool = false
var disable_mouse_features: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_fill_infos()
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)


func _fill_infos() -> void:
	_fill_entity_infos(entity_infos)
	if entity_infos is LivingInfos:
		_fill_living_infos(entity_infos as LivingInfos)
	if entity_infos is FishInfos:
		_fill_fish_infos(entity_infos as FishInfos)
	if entity_infos is PlantInfos:
		_fill_plant_infos(entity_infos as PlantInfos)


func _fill_entity_infos(entity_infos: EntityInfos) -> void:
	name_label.text = entity_infos.display_name
	entity_texture.texture = entity_infos.texture
	if entity_infos.temperature_variation:
		temperature_condition_variation_label.text = str(entity_infos.temperature_variation)
	else:
		temperature_condition_variation_label.text = "-"
	if entity_infos.oxygen_variation:
		oxygen_condition_variation_label.text = str(entity_infos.oxygen_variation)
	else:
		oxygen_condition_variation_label.text = "-"
	if entity_infos.quality_variation:
		quality_condition_variation_label.text = str(entity_infos.quality_variation)
	else:
		quality_condition_variation_label.text = "-"
	if entity_infos.acidity_variation:
		acidity_condition_variation_label.text = str(entity_infos.acidity_variation)
	else:
		acidity_condition_variation_label.text = "-"

func _fill_living_infos(living_infos: LivingInfos) -> void:
	temperature_condition_value_label.text = str(living_infos.min_temperature) + "-" + str(living_infos.max_temperature)
	oxygen_condition_value_label.text = str(living_infos.min_oxygen_saturation) + "-" + str(living_infos.max_oxygen_saturation)
	quality_condition_value_label.text = str(living_infos.min_quality) + "-" + str(living_infos.max_quality)
	acidity_condition_value_label.text = str(living_infos.min_acidity) + "-" + str(living_infos.max_acidity)



func _fill_fish_infos(plant_infos: FishInfos) -> void:
	pass


func _fill_plant_infos(plant_infos: PlantInfos) -> void:
	pass

func _process(delta: float) -> void:
	if drag_enabled:
		global_position = get_global_mouse_position() + drag_position




func _on_mouse_entered() -> void:
	if disable_mouse_features:
		return
	if !drag_enabled:
		base_position = global_position
	global_position = global_position + Vector2.UP * selection_position_offset


func _on_mouse_exited() -> void:
	if disable_mouse_features:
		return
	global_position = base_position


func _on_gui_input(event: InputEvent) -> void:
	if disable_mouse_features && !drag_enabled:
		return
	if (event is InputEventMouseButton):
		if event.is_action_pressed("click"):
			drag_position = global_position - get_global_mouse_position()
			drag_enabled = true
			dragged.emit(drag_enabled)
			z_index = 1
		if event.is_action_released("click"):
			drag_enabled = false
			global_position = base_position
			dragged.emit(drag_enabled)
			z_index = 0

