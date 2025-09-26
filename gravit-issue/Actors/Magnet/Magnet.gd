extends Sprite2D
class_name Magnet

@export var strength := 300.0
@export var detection_length := 200.0
@export var release_length = 50.0
var active := false

func _on_start_attraction() -> void:
	active = true
	GameInstance.getLevelManager().player.kill_input = true

func _on_stop_attraction() -> void:
	active = false
	GameInstance.getLevelManager().player.kill_input = false
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Magnet") && detection_length > (position - GameInstance.getLevelManager().player.position).length():
		if active : _on_stop_attraction()
		else : _on_start_attraction()
		
	if active:
		var player := GameInstance.getLevelManager().player
		player.velocity += (position - player.position) * strength * delta
		player.move_and_slide()
		
		if (player.position - position).length() < release_length:
			_on_stop_attraction()
		elif player.is_on_floor() or player.is_on_ceiling():
			_on_stop_attraction()
		
		
