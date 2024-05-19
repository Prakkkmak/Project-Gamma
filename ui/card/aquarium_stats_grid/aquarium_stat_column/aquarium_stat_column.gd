class_name AquariumStatColumn
extends VBoxContainer


@export var stat: Stat
@export var living_infos: LivingInfos

@onready var display_symbol: Label = %DisplaySymbol
@onready var requirement_unit_progress_bar: UnitProgressBar = %RequirementUnitProgressBar
@onready var variation_label: Label = %VariationLabel
@onready var requirement_none_label: Label = %RequirementNoneLabel

func fill() -> void:
	display_symbol.text = stat.symbol_name
	requirement_unit_progress_bar.max = stat.max_value
	requirement_unit_progress_bar.min = stat.min_value
	var requirement: StatRequirement = living_infos.get_stat_requirements(stat)
	if requirement:
		requirement_unit_progress_bar.value = requirement.target
		requirement_unit_progress_bar.generate()
		requirement_none_label.hide()
		requirement_unit_progress_bar.show()
	else: 
		requirement_none_label.show()
		requirement_unit_progress_bar.hide()
	var variation: StatVariation = living_infos.get_stat_variation(stat)
	variation_label.text = "X"
	if variation:
		if variation.variation > 0:
			variation_label.text = "+"
		if variation.variation > 1:
			variation_label.text = "++"
		if variation.variation > 3:
			variation_label.text = "+++"
		if variation.variation < 0:
			variation_label.text = "-"
		if variation.variation < -1:
			variation_label.text = "--"
		if variation.variation < -3:
			variation_label.text = "---"
