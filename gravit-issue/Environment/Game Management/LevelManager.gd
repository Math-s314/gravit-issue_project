extends Node2D
class_name LevelManager

signal player_death()

@export_range(0, 15, 1, "hide_slider") var level_number : int
var player : Player = null

func _enter_tree() -> void:
	GameInstance.current_lvl = level_number

func declare_player_death():
	player_death.emit()
