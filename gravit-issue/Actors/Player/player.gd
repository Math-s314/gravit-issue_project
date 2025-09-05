extends CharacterBody2D
class_name Player

@export_group("Gravity")
@export var gravity_strength := 500.0;
@export var transition_duration := 0.5
@export var still_duration := 10.0
#@export_exp_easing var transition_speed := 1.0

@export_group("Controls")
@export var move_speed := 250.0
@export var jump_force := 250.0

@export_group("Display")
@export var min_particle_speed : float = 30.0
@export var max_particle_speed : float = 50.0


## Gravity switching
var gravity_switch := 1.0;
var gravity_transition := false
@onready var gravity_timer := $GravityTimer
@onready var sprite := $Sprite2D
@onready var particles := $CPUParticles2D

func _ready() -> void:
	gravity_timer.wait_time = still_duration

func _process(delta: float) -> void:
	# Gravity
	print(is_on_floor())
	if(!is_on_floor()): velocity.y += get_gravity_coef() * gravity_strength * delta;
	else: velocity.y = 0.0
	
	# Player input
	var inputAxis :=  Input.get_axis("Left", "Right")
	particles.direction.x = -inputAxis
	#particles.initial_velocity_min = lerp(min_particle_speed, 1.5 * min_particle_speed, abs(inputAxis))
	#particles.initial_velocity_max = lerp(max_particle_speed, 1.5 * max_particle_speed, abs(inputAxis))
	velocity = Vector2(inputAxis * move_speed, velocity.y)

	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = -gravity_switch * jump_force

	move_and_slide()

func get_gravity_coef() -> float:
		if(!gravity_transition):
			return gravity_switch
		else:
			var progress : float = gravity_timer.time_left/transition_duration;
			return gravity_switch * cos(PI * progress)
	
func _on_gravity_switch():
	if(gravity_transition): # Starting still period
		scale.y = gravity_switch
		gravity_transition = false
		gravity_timer.wait_time = still_duration
	else: # Starting transition period
		gravity_transition = true
		gravity_timer.wait_time = transition_duration
		gravity_switch = -gravity_switch
		up_direction.y = -up_direction.y
	gravity_timer.start();
