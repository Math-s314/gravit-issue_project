extends Spawner
class_name CommandCenter

@export var player : PackedScene

func pre_enable() -> void:
	pass
	
func enable() -> void:
	pass
	
func spawn_player(_player : Player) -> void:
	pass

func _on_body_entered(body:Node2D) -> void:
	if body is Player: pre_enable()
