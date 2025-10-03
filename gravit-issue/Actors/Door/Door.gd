extends Spawner

@export var connected_level : int
@export var connected_door : NodePath = ^"Door"

var active := true

func spawn_player(player : Player) -> void:
	active = true
	player.position = to_global(Vector2(-50, 20))
	player.freeze = false
	
func _on_body_entered(body:Node2D) -> void:
	if active and body is Player : GameInstance.switch_scene(connected_level, connected_door)

func _on_body_exited(body:Node2D) -> void:
	if body is Player : active = true # Replace with function body.
