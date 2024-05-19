class_name Stat
extends Resource

@export var id: String = "stat"

@export var display_name: String = "Stat"

@export var symbol_name: String = "ST"

@export var description: String = "A basic stat"

@export var min_value: float = 0.0

@export var max_value: float = 200.0

@export var neutral_value: float = 100.0

@export var variation_ratio: float = 1.0

@export var equilibre_factor: float = 1.0

@export var stable_delta: float = 10.0

@export var critical_delta: float = 40.0

@export var current_value: float = 100.0

@export var one_shot: bool = false

func apply_variation(variation: float) -> void:
	# Si le facteur d'équilibre n'est pas 1.0, appliquer un ajustement basé sur la distance
	#FIXME FACTOR TO TEST
	if equilibre_factor != 1.0:
		var distance: float = abs(current_value - neutral_value)  # Calculer la distance entre la valeur actuelle et la valeur d'équilibre
		var adjustment: float = 1.0 / (1.0 + distance)  # Calculer l'ajustement basé sur la distance (plus la distance est grande, plus l'ajustement est petit)
		variation *= adjustment ** equilibre_factor  # Ajuster la variation en utilisant le facteur d'équilibre
	variation *= variation_ratio  # Appliquer le modificateur linéaire pour ajuster la vitesse de variation
	var new_value: float = current_value + variation  # Calculer la nouvelle valeur après l'application de la variation
	current_value = clamp(new_value, min_value, max_value)  # Limiter la nouvelle valeur entre les bornes min et max
