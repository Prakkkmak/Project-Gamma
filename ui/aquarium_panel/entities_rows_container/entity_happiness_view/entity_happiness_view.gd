class_name EntityHappinessView
extends PanelContainer

@export var infos: EntityInfos

@onready var progress_bar: ProgressBar = %ProgressBar

@onready var amount_label: Label = %AmountLabel
@onready var texture_rect: TextureRect = %TextureRect

var locked: bool = true

func _ready() -> void:
	texture_rect.texture = infos.texture
	lock()


func lock() -> void:
	amount_label.modulate = Color.BLACK
	texture_rect.modulate = Color.BLACK
	progress_bar.hide()
	locked = true


func unlock() -> void:
	amount_label.modulate = Color.WHITE
	texture_rect.modulate = Color.WHITE
	progress_bar.show()
	locked = false

func set_happiness(happiness: HappinessStats) -> void:
	if locked:
		unlock()
	progress_bar.value = happiness.average()
	
func set_count(count: int) -> void:
	if locked:
		unlock()
	amount_label.text = str(count)
