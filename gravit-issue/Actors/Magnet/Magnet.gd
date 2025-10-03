extends Area2D
class_name Magnet

@export var strength : float
@export var detection_length : float
@export var release_length : float

var active := false

func _on_start_attraction() -> void:
	active = true
	GameInstance.getLevelManager().player.kill_mvt_input = true

func _on_stop_attraction() -> void:
	active = false
	GameInstance.getLevelManager().player.kill_mvt_input = false
	
func _on_body_entered(body : Node2D) -> void:
	if body is Player : _on_stop_attraction()
	
func check_player_release() -> bool:
	var player : Player = GameInstance.getLevelManager().player
	return (player.position - position).length() < release_length \
		|| player.is_on_floor() || player.is_on_ceiling() \
		|| player.freeze
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Magnet") && detection_length > (position - GameInstance.getLevelManager().player.position).length():
		if active : _on_stop_attraction()
		else : _on_start_attraction()
		
	if active:
		var player : Player = GameInstance.getLevelManager().player
		player.velocity += (position - player.position) * strength * delta
		player.move_and_slide()
		
		if check_player_release():
			_on_stop_attraction()
