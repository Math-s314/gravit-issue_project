extends StaticBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_open: bool = false
	
func change_state() -> void:
	is_open = not is_open
	if(is_open):
		animation_player.play("animation")
	else:
		animation_player.play_backwards("animation")


func _on_lever_2_activate() -> void:
	pass # Replace with function body.
