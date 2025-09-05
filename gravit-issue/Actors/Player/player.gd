extends CharacterBody2D
class_name Player

@export_group("Gravity")
@export var gravity_strength := 200.0;
@export var transition_duration := 2.0
@export var still_duration := 10.0
#@export_exp_easing var transition_speed := 1.0

@export_group("Controls")
@export var move_speed := 100.0
@export var jump_force := 150.0


## Gravity switching
var gravity_switch := 1.0;
var gravity_transition := false
@onready var gravity_timer := $GravityTimer

func _ready() -> void:
	gravity_timer.wait_time = still_duration

func _process(delta: float) -> void:
	# Gravity
	if(!is_on_floor()):
		velocity.y += get_gravity_coef() * gravity_strength * delta;
	else:
		velocity.y = 0.0
	
	# Player input
	var inputAxis := Input.get_axis("Left", "Right")
	print(up_direction.y)
	velocity = Vector2(inputAxis * move_speed, velocity.y)

	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = -gravity_switch * jump_force

	move_and_slide()

func get_gravity_coef() -> float:
		if(!gravity_transition):
			return gravity_switch
		else:
			return gravity_switch * cos(PI * gravity_timer.time_left/transition_duration)
	
func _on_gravity_switch():
	if(gravity_transition):
		gravity_transition = false
		gravity_timer.wait_time = still_duration
	else:
		gravity_transition = true
		gravity_timer.wait_time = transition_duration
		gravity_switch = -gravity_switch
		up_direction.y = -up_direction.y
	gravity_timer.start();
