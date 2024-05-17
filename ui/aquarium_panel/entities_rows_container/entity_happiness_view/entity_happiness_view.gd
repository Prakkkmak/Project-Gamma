class_name EntityHappinessView
extends PanelContainer

@export var infos: EntityInfos

@onready var progress_bar: ProgressBar = %ProgressBar

@onready var amount_label: Label = %AmountLabel
@onready var texture_rect: TextureRect = %TextureRect

var locked: bool = true
var current_happiness: HappinessStats

func _ready() -> void:
	texture_rect.texture = infos.get_texture_display()
	lock()


func lock() -> void:
	amount_label.modulate = Color.BLACK
	texture_rect.modulate = Color.BLACK
	progress_bar.modulate = Color.BLACK
	locked = true


func unlock() -> void:
	amount_label.modulate = Color.WHITE
	texture_rect.modulate = Color.WHITE
	progress_bar.modulate = Color.WHITE
	locked = false

func set_happiness(happiness: HappinessStats) -> void:
	if locked:
		unlock()
	progress_bar.value = happiness.min()
	progress_bar.modulate = lerp(Color.RED, Color.WHITE, progress_bar.value)
	current_happiness = happiness
	
func set_count(count: int) -> void:
	if locked:
		unlock()
	amount_label.text = str(count)
