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
var gravity_dir := 1.0; # UP is 1, DOWN is -1
var gravity_transition := false
var Animation_playing := false
@onready var gravity_timer := $GravityTimer
@onready var jump_timer := $JumpTimer
@onready var sprite := $AnimatedSprite2D
@onready var particles := $CPUParticles2D

## Display informations
const EPSILON := 1e-2
const BASE_EMITTER := Transform2D(0.0, Vector2(0.0, 27.0))
const WALKING_EMITTER := Transform2D(deg_to_rad(35.0), Vector2(-8.0, 24.5))
const MID_DOWN_EMITTER := Transform2D(0.0, Vector2(0.0, 21.5))
const MID_UP_EMITTER := Transform2D(deg_to_rad(180.0), Vector2(0.0, -21.5))

var min_particle_speed : float
var max_particle_speed : float

## Input information
var inputAxis := 0.0
var freeze := false

func _enter_tree() -> void:
	GameInstance.getLevelManager().player = self

func _ready() -> void:
	gravity_timer.start(still_duration)
	min_particle_speed = particles.initial_velocity_min
	max_particle_speed = particles.initial_velocity_max
	
	sprite.play(&"Idle") # To avoid blocking animations...


func _process(delta: float) -> void:
	# Gravity
	if(!is_on_floor()): velocity.y += get_gravity_coef() * gravity_strength * delta;
	else: velocity.y = 0.0

	if !freeze :
		handle_input()
		handle_animation()
		handle_particle()
		move_and_slide()
	elif Animation_playing == false :
		sprite.play(&"Idle")
		handle_particle()

func get_gravity_coef() -> float:
		if(!gravity_transition):
			return gravity_dir
		else:
			var progress : float = gravity_timer.time_left/transition_duration;
			return gravity_dir * cos(PI * progress)

func handle_input() -> float:
	inputAxis =  Input.get_axis("Left", "Right") * (1.0 if is_on_floor() else air_control)

	if Input.is_action_just_pressed("Jump") && is_on_floor():
		velocity.y = -gravity_dir * jump_force
		explose_particles(true)
		jump_timer.start()
		
	velocity = Vector2(inputAxis * move_speed, velocity.y)

	if Input.is_action_just_released("Gravité") : _on_gravity_switch()
	
	return inputAxis
	
func handle_animation(ended := &"") -> void:
	# Blocking animations
	if sprite.animation == &"Demi-tour" and ended != &"Demi-tour" : return
	if sprite.animation == &"Renversement" and ended != &"Renversement" : return
	if Animation_playing == true : return;
	
	# Looping animations
	if abs(inputAxis) > EPSILON :
		if inputAxis > 0.0 and sprite.flip_h == true : sprite.play(&"Demi-tour")
		elif inputAxis  < 0.0 and sprite.flip_h == false : sprite.play(&"Demi-tour")
		else : sprite.play(&"Walking")
		
	elif abs(inputAxis) < EPSILON :
		sprite.play(&"Idle")
		particles.transform = BASE_EMITTER

func handle_particle() -> void:
	var kill := false
	
	match sprite.animation:
		&"Demi-tour": particles.transform = BASE_EMITTER
		&"Walking":
			particles.transform = WALKING_EMITTER
			particles.position.x *= -1.0 if sprite.flip_h else 1.0
			particles.rotation *= -1.0 if sprite.flip_h else 1.0
		&"Renversement":
			match sprite.frame:
				0: particles.transform = MID_DOWN_EMITTER
				1: kill = true
				2: particles.transform = MID_UP_EMITTER
		_: particles.transform = BASE_EMITTER
	
	particles.visible = !kill
	
func explose_particles(expl : bool) :
	if expl :
		particles.emission_rect_extents.x = 7.0
		particles.spread = 70.0
		particles.scale_amount_min = 0.03
		particles.scale_amount_max = 0.06
		particles.color = Color(1.0, 1.0, 0.196)
	else:
		particles.emission_rect_extents.x = 4.0
		particles.spread = 20.0
		particles.scale_amount_min = 0.01
		particles.scale_amount_max = 0.02
		particles.color = Color(0.0, 1.0, 1.0)
		
func _on_PlayerArea_body_entered(body : Node2D):
	print("fonction lancée")
	if body.name == "Laser": 
		print("eljkfbezjfezykf")
		Animation_playing = true
		sprite.play(&"Mort")  
		
func _on_gravity_switch():
	if(gravity_transition): # Ending transition period
		gravity_transition = false
		gravity_timer.wait_time = still_duration
	else: # Starting transition period
		gravity_transition = true
		gravity_timer.wait_time = transition_duration
		gravity_dir = -gravity_dir
		sprite.play(&"Renversement")
	gravity_timer.start();

func _on_animation_looped() -> void:
	if sprite.animation == &"Demi-tour" :
		sprite.flip_h = not sprite.flip_h
		sprite.stop()
		
		handle_animation(&"Demi-tour")
		handle_particle()
		
	if sprite.animation == &"Renversement"  :
		scale.y = gravity_dir * abs(scale.y)
		up_direction.y = -gravity_dir
		sprite.stop()

		handle_animation(&"Renversement")
		handle_particle()
	
	if sprite.animation == &"Mort":
		Animation_playing = false
		
func _on_jump_end() -> void:
	explose_particles(false)
	
