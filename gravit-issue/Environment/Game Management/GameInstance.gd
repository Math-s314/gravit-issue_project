extends Node
class_name _GameInstance

enum TransitionState {NO_TRANSITION, DISAPPEAR, APPEAR}

@export var transition_duration : float
@export var levels : Array[PackedScene]

## Transition memory
var current_lvl := 0
var next_lvl    := 0

var spawn_path : NodePath
var in_transition := TransitionState.NO_TRANSITION
var timer := 0.0

func getLevelManager() -> LevelManager :
	return get_tree().get_root().get_child(1)

func _process(delta: float) -> void:
	if in_transition != TransitionState.NO_TRANSITION:
		timer += delta/transition_duration
		
		if timer > 0.5 && in_transition == TransitionState.DISAPPEAR: _switch()
		if timer > 1.0: _end_switch()
		
		if in_transition == TransitionState.DISAPPEAR: getLevelManager().modulate = Color(1-2*timer, 1-2*timer, 1-2*timer)
		else : getLevelManager().modulate = Color(2*timer-1, 2*timer-1, 2*timer-1)
		
func _switch() -> void:
	in_transition = TransitionState.APPEAR

	var current : LevelManager = getLevelManager()
	var next : LevelManager    = levels[next_lvl].instantiate()
	
	# Player
	next.player = current.player
	current.remove_child(next.player)
	next.add_child(next.player)
	
	# Scene switch
	get_tree().get_root().remove_child(current)
	get_tree().get_root().add_child(next)
	current_lvl = next_lvl
	getLevelManager().modulate = Color.WHITE
	current.queue_free()
	
	# Spawn
	_spawn_player()
	
func _spawn_player():
	var spawner : Spawner = getLevelManager().get_node(spawn_path)
	spawner.spawn_player(getLevelManager().player)
	
func _end_switch() -> void:
	in_transition = TransitionState.NO_TRANSITION
		
func switch_scene(future_lvl : int, spawner : NodePath, ff_possible := false) -> void :
	var player := getLevelManager().player
	spawn_path = spawner
	next_lvl = future_lvl
	
	if !ff_possible || next_lvl != current_lvl:
		timer = 0.0
		player.freeze = true
		in_transition = TransitionState.DISAPPEAR
	else:
		_spawn_player()
