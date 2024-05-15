class_name Deck
extends Resource

@export var elements: Array[EntityInfos] = []


const rarity_weight: Dictionary = {
	EntityInfos.Rarity.D: 90,
	EntityInfos.Rarity.C: 30,
	EntityInfos.Rarity.B: 15,
	EntityInfos.Rarity.A: 7,
	EntityInfos.Rarity.S: 1,
}

var rarity_elements: Dictionary = {
	EntityInfos.Rarity.D: [],
	EntityInfos.Rarity.C: [],
	EntityInfos.Rarity.B: [],
	EntityInfos.Rarity.A: [],
	EntityInfos.Rarity.S: [],
}

var rarities_not_empty: Array[EntityInfos.Rarity] = []
var total_weight: int = 0


func generate() -> void:
	rarities_not_empty = []
	total_weight = 0
	for rarity: EntityInfos.Rarity  in rarity_elements.keys():
		var elements_in_rarity: Array[EntityInfos] = get_elements_in_rarity(rarity)
		print("put rarity " + str(rarity))
		rarity_elements[rarity] = elements_in_rarity
		if !elements_in_rarity.is_empty():
			rarities_not_empty.append(rarity)
	_calculate_total_weight()


func pick_random_weighted() -> EntityInfos:
	var rarity: EntityInfos.Rarity = pick_rarity()
	if rarity == EntityInfos.Rarity.INVALID:
		return null
	var elements: Array[EntityInfos] = rarity_elements[rarity]
	return elements.pick_random()


func pick_rarity(ignore_empty_rarities: bool = true) -> EntityInfos.Rarity:
	var chosen_weight: int = randi_range(1, total_weight)
	var iteration_sum: int = 0
	var rarity_pool: Array[EntityInfos.Rarity] = []
	if ignore_empty_rarities:
		rarity_pool = rarities_not_empty
	else:
		rarity_pool = rarity_weight.keys()
	for rarity: EntityInfos.Rarity in rarity_pool:
		iteration_sum += rarity_weight.get(rarity)
		if chosen_weight <= iteration_sum:
			return rarity
	return EntityInfos.Rarity.INVALID


func get_elements_in_rarity(rarity: EntityInfos.Rarity) -> Array[EntityInfos]:
	var found_elements: Array[EntityInfos] = []
	for element: EntityInfos in elements:
		if element.rarity == rarity:
			found_elements.append(element)
	return found_elements

func _calculate_total_weight() -> int:
	total_weight = 0
	for rarity: EntityInfos.Rarity in rarities_not_empty:
		total_weight += rarity_weight.get(rarity)
	return total_weight
