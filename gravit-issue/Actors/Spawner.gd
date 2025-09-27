extends Node2D
class_name Spawner

func spawn_player(player : Player):
	player.freeze = false
	player.position = Vector2.ZERO
