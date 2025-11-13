extends Area2D



func _on_body_entered(body: Node2D) -> void:
	if body is Player :
		body.gravity_strength = 0 
		body.zero_gravity = true
		body.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
		
