extends Node

enum TransitionState {NO_TRANSITION, DISAPPEAR, APPEAR}

@export var transition_duration : float = 5.0

## Transition memory
var next : PackedScene   = null

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

	var currentInst :LevelManager = getLevelManager()
	var nextInst : LevelManager = next.instantiate()
	
	nextInst.player = currentInst.player
	currentInst.remove_child(nextInst.player)
	nextInst.add_child(nextInst.player)

	get_tree().get_root().remove_child(currentInst)
	get_tree().get_root().add_child(nextInst)

	nextInst.player.freeze = false
	nextInst.modulate.a = 1.0
	currentInst.queue_free()
	
	var spawner : Spawner = nextInst.get_node(spawn_path)
	spawner.spawn_player(nextInst.player)
	
func _end_switch() -> void:
	in_transition = TransitionState.NO_TRANSITION
		
func switch_scene(future_scene : PackedScene, spawner : NodePath) -> void :
	spawn_path = spawner
	next = future_scene

	timer = 0.0
	getLevelManager().modulate.a = 0.0
	getLevelManager().player.freeze = true
	in_transition = TransitionState.DISAPPEAR
