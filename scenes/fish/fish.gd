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
@onready var die: AtomicState = $StateChart/Root/Movement/Die

@onready var health_label: Label = %HealthLabel
@onready var food_label: Label = %FoodLabel
@onready var name_label: Label = %NameLabel

@onready var sprite: Sprite2D = $ScalePivot/Sprite2D

@onready var food_component: FoodComponent = $FoodComponent



var aquarium: Aquarium

var current_health: float = 0.0
var current_food: float = 0.0

var current_target: Vector2 = Vector2.ZERO
var target_food: FoodComponent

var max_speed: float = 200
var acceleration: float = 1

var is_dead: bool = false


func _ready() -> void:
	if infos:
		current_health = infos.max_health
		current_food = infos.max_food
		max_speed = infos.max_speed
		acceleration = infos.acceleration
		name_label.text = infos.display_name
		scale = scale * infos.scale
		sprite.texture = infos.texture
	swiming.state_entered.connect(_on_swiming_state_entered)
	swiming.state_physics_processing.connect(_on_swiming_state_physics_processing)
	idle.state_entered.connect(_on_idle_state_entered)
	locate_food.state_entered.connect(_on_locate_food_entered)
	swiming_to_food.state_physics_processing.connect(_on_swiming_to_food_state_physics_processing)
	swiming_to_food.state_entered.connect(_on_swiming_to_food_state_entered)
	eating.state_entered.connect(_on_eating_state_entered)
	eating.state_processing.connect(_on_eating_state_processing)
	die.state_entered.connect(_on_die_state_entered)
	if !infos.is_eddible:
		food_component.queue_free()
		food_component = null
	else:
		food_component.max_food = infos.max_food
		food_component.eated.connect(_on_eated)
		food_component.eated_finished.connect(_on_eated_finished)
	

func _process(delta: float) -> void:
	if is_dead:
		return
	current_food -= delta
	if current_food < 0:
		take_damage(delta)
	food_label.text = "Food: " + str(floor(current_food))
	health_label.text = "Health: " + str(floor(current_health))
	for stat_requirement: StatRequirement in infos.stats_requirements:
		var condition_delta: float = abs(stat_requirement.get_outside_requirement_delta())
		if condition_delta > 0:
			take_damage(delta)


func take_damage(amount: float) -> void:
	animation_player.play("hurt")
	current_health -= amount
	if current_health < 0:
		state_chart.send_event("die")


func is_food_needed() -> bool:
	return current_food <= infos.food_threshold


func _swim(delta: float) -> void:
	var direction: Vector2 = (navigation_agent.get_next_path_position() - global_position).normalized()
	velocity = velocity.lerp(direction * max_speed, 1 - exp(-acceleration * delta))
	if !infos.fixed_rotation:
		look_at(global_position + velocity)
		sprite.flip_v = velocity.x < 0
	move_and_slide()



func _find_new_target_position() -> void:
	var new_position: Vector2 = Vector2(randi_range(-600,600), randi_range(-650,0))
	navigation_agent.target_position = new_position


func _find_target_food() -> FoodComponent:
	var nodes: Array[Node] = get_tree().get_nodes_in_group("food")
	var target_food_to_return: Node2D = null
	for node: Node in nodes:
		if !(node is FoodComponent):
			push_error("Food not food component")
		var food_component: FoodComponent = node as FoodComponent
		if infos.food_regimes.find(food_component.food_type) == -1 || !food_component.is_eddible():
			continue
		if !target_food_to_return || (global_position.distance_to(food_component.global_position) < global_position.distance_to(target_food_to_return.global_position)):
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


func _on_swiming_to_food_state_entered() -> void:
	animation_player.play("swim")

func _on_swiming_to_food_state_physics_processing(delta: float) -> void:
	if target_food:
		navigation_agent.target_position = target_food.global_position
	if navigation_agent.is_navigation_finished():
		state_chart.send_event("food_reached")
	else:
		_swim(delta)


func _on_eating_state_entered() -> void:
	if target_food && current_food < infos.max_food:
		target_food.start_eating()
		animation_player.play("eat")


func _on_eating_state_processing(delta: float) -> void:
	if target_food:
		if current_food < infos.max_food:
			var eated: float = target_food.eat(delta * 5)
			current_food += eated
		else:
			target_food.stop_eating()
			target_food.depleted.disconnect(_on_food_depleted)
			target_food = null
			state_chart.send_event("swim")
	else:
		state_chart.send_event("idle")


func _on_food_depleted() -> void:
	target_food.stop_eating()
	target_food.depleted.disconnect(_on_food_depleted)
	target_food = null
	state_chart.send_event.call_deferred("idle")


func _on_die_state_entered() -> void:
	is_dead = true
	sprite.flip_v = false
	animation_player.play("die")
	if food_component:
		food_component.queue_free()


func _on_eated(old_amount: float, new_amount: float) -> void:
	animation_player.play("hurt")
	max_speed = 0


func _on_eated_finished() -> void:
	state_chart.send_event("die")
#endregion


