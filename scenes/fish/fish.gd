class_name Fish
extends CharacterBody2D

@export var infos: FishInfos


@onready var state_chart: StateChart = %StateChart
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


@onready var swiming: AtomicState = %Swiming
@onready var idle: AtomicState = %Idle
@onready var locate_food: AtomicState = %LocateFood
@onready var swiming_to_food: AtomicState = %SwimingToFood
@onready var eating: AtomicState = %Eating

@onready var health_label: Label = %HealthLabel
@onready var food_label: Label = %FoodLabel
@onready var name_label: Label = %NameLabel


var current_health: int = 10
var current_food: float = 5


var current_target: Vector2 = Vector2.ZERO
var target_food: FoodComponent

var max_speed: float = 200
var acceleration: float = 1


func _ready() -> void:
	if infos:
		current_health = infos.max_health
	name_label.text = infos.display_name
	swiming.state_entered.connect(_on_swiming_state_entered)
	swiming.state_physics_processing.connect(_on_swiming_state_physics_processing)
	idle.state_entered.connect(_on_idle_state_entered)
	locate_food.state_entered.connect(_on_locate_food_entered)
	swiming_to_food.state_physics_processing.connect(_on_swiming_to_food_state_physics_processing)
	eating.state_entered.connect(_on_eating_state_entered)
	eating.state_processing.connect(_on_eating_state_processing)
	

func _process(delta: float) -> void:
	current_food -= delta
	food_label.text = "Food: " + str(floor(current_food))
	health_label.text = "Health: " + str(current_health)

func _physics_process(delta: float) -> void:
	pass


func is_food_needed() -> bool:
	return current_food <= infos.food_threshold


func _swim(delta: float) -> void:
	var direction: Vector2 = (navigation_agent.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * max_speed, 1 - exp(-acceleration * delta))
	move_and_slide()


func _find_new_target_position() -> void:
	var new_position: Vector2 = Vector2(randi_range(-500,500), randi_range(-200,200))
	print("Target position: " + str(new_position))
	navigation_agent.target_position = new_position


func _find_target_food() -> FoodComponent:
	var nodes: Array[Node] = get_tree().get_nodes_in_group("food")
	var target_food_to_return: Node2D = null
	for node: Node in nodes:
		if !(node is FoodComponent):
			push_error("Food not food component")
		var food_component: FoodComponent = node as FoodComponent
		if infos.food_regimes.find(food_component.food_type) == -1 || !food_component.is_eddible():
			print("! Food is not the good type")
			continue
		print("Food is the good type because is eddible " + str(food_component.is_eddible()))
		if !target_food_to_return || (global_position.distance_to(food_component.global_position) < global_position.distance_to(target_food_to_return.global_position)):
			print("Target acquiered")
			target_food_to_return = food_component
	return target_food_to_return


#region States Callbacks


func _on_idle_state_entered() -> void:
	if is_food_needed():
		state_chart.send_event("hungry")
	else:
		state_chart.send_event("swim")


func _on_swiming_state_entered() -> void:
	animation_player.play("swim")
	_find_new_target_position()


func _on_swiming_state_physics_processing(delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		state_chart.send_event("idle")
	else:
		_swim(delta)


func _on_locate_food_entered() -> void:
	target_food = _find_target_food()
	if target_food:
		target_food.depleted.connect(_on_food_depleted)
		state_chart.send_event("food_located")
	else:
		state_chart.send_event("swim")


func _on_swiming_to_food_state_physics_processing(delta: float) -> void:
	print("Target food " + str(target_food))
	if target_food:
		print("Target food  aftr if" + str(target_food))
		navigation_agent.target_position = target_food.global_position
	if navigation_agent.is_navigation_finished():
		state_chart.send_event("food_reached")
	else:
		_swim(delta)


func _on_eating_state_entered() -> void:
	animation_player.play("eat")


func _on_eating_state_processing(delta: float) -> void:
	if target_food && current_food < infos.max_food:
		var eated: float = target_food.eat(delta * 10)
		current_food += eated
	else:
		print("Free target food from var")
		target_food = null
		state_chart.send_event("idle")


func _on_food_depleted() -> void:
	print("Food depleted, so stop focus")
	target_food = null
	state_chart.send_event.call_deferred("idle")

#endregion


