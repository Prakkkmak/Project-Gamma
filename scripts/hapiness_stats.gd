class_name HappinessStats
extends Resource


enum HappinessFeatureType { FOOD, OXYGEN }


var _happiness_features: Dictionary = {}


func get_happiness_features() -> Dictionary:
	return _happiness_features.duplicate() 


func add_feature(type: HappinessFeatureType, value: float) -> void:
	_happiness_features[type] = clamp(value, 0.0, 1.0)


func average() -> float:
	var average: float = 0.0
	for happiness_feature: float in _happiness_features.values():
		assert(happiness_feature is float)
		if !(happiness_feature is float):
			push_error("Happiness feature not float")
			continue
		var happiness_feature_value: float = clamp(happiness_feature as float,0.0 , 1.0)
		average += happiness_feature_value
	return average / _happiness_features.size()
