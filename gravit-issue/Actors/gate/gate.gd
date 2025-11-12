extends StaticBody2D

@onready var animation: AnimationPlayer = $AnimationPlayer
var is_open: bool                       = false

func _ready() -> void:
	is_open = (GameInstance.get_node_data(self) == true)
	animation.play(&"open" if is_open else &"close")

func change_state() -> void:
	is_open = not is_open
	GameInstance.set_node_data(self, is_open)
	if(is_open):
		animation.play("animation")
	else:
		animation.play_backwards("animation")
		
func change_state_delayed() -> void:
	await get_tree().create_timer(3).timeout
	change_state()
