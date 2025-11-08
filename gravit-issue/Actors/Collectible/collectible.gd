extends Area2D
class_name Collectible

@onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if(GameInstance.get_node_data(self)):
		visible = false
		queue_free()
		
func collected(_player : Player):
	GameInstance.set_node_data(self, true)
	print("Collected !!")
	anim_player.play(&"HOP")	

func _on_body_entered(body:Node2D) -> void:
	if body is Player: collected(body as Player)
