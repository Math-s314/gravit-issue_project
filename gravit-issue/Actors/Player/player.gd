extends CharacterBody2D
class_name Player

@export_group("Gravity")
@export var gravity_strength : float
@export var transition_duration : float
@export var still_duration : float
#@export_exp_easing var transition_speed := 1.0

@export_group("Controls")
@export var move_speed : float
@export var jump_force : float
@export var air_control : float

## Gravity switching
var gravity_switch := 1.0;
var gravity_transition := false
@onready var gravity_timer := $GravityTimer
@onready var sprite := $AnimatedSprite2D
@onready var particles := $CPUParticles2D

## Display informations
const EPSILON := 1e-2
const BASE_EMITTER := Transform2D(0.0, Vector2(0.0, 19.0))
const WALKING_EMITTER := Transform2D(deg_to_rad(47.0), Vector2(-10.0, 16.3))

var min_particle_speed : float
var max_particle_speed : float

func _ready() -> void:
	gravity_timer.wait_time = still_duration
	min_particle_speed = particles.initial_velocity_min
	max_particle_speed = particles.initial_velocity_max

func _process(delta: float) -> void:
	# Gravity
	if(!is_on_floor()): velocity.y += get_gravity_coef() * gravity_strength * delta;
	else: velocity.y = 0.0
	
	# Player input
	var inputAxis :=  Input.get_axis("Left", "Right") * (1.0 if is_on_floor() else air_control)
	particles.initial_velocity_min = lerp(min_particle_speed, 1.5 * min_particle_speed, abs(inputAxis))
	particles.initial_velocity_max = lerp(max_particle_speed, 1.5 * max_particle_speed, abs(inputAxis))
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	
	if abs(inputAxis) > EPSILON and sprite.animation != &"Demi-tour":
		if inputAxis > 0.0 and sprite.flip_h == true :
			sprite.play(&"Demi-tour")
			particles.transform = BASE_EMITTER
		elif inputAxis  < 0.0 and sprite.flip_h == false : 
			sprite.play(&"Demi-tour")
			particles.transform = BASE_EMITTER
		else : 
			sprite.play("Walking")
			particles.transform = WALKING_EMITTER
			particles.position.x *= -1.0 if sprite.flip_h else 1.0
			particles.rotation *= -1.0 if sprite.flip_h else 1.0
	elif abs(inputAxis) < EPSILON :
		sprite.play("Idle")
		particles.transform = BASE_EMITTER
	
	
	

	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = -gravity_switch * jump_force

	move_and_slide()
	
	if Input.is_action_just_pressed("Gravité") :
		_on_gravity_switch()
	

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

func _on_animation_looped() -> void:
	if sprite.animation == "Demi-tour" :
		sprite.flip_h = not sprite.flip_h
		sprite.stop()
		print("fkseiopf")
		sprite.play("Walking") # Replace with function body.
