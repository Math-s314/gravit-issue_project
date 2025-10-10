extends Spawner
class_name CommandCenter

@onready var sprite := $AnimatedSprite2D
var respawning_player : Player = null

func _ready() -> void:
	sprite.animation = &"default"

func register_checkpoint(player : Player) -> void:
	player.last_checkpoint_lvl = GameInstance.getLevelManager().level_number
	player.last_checkpoint_spa = GameInstance.getLevelManager().get_path_to(self)

func pre_enable() -> void:
	pass
	
func enable() -> void:
	pass
	
func spawn_player(player : Player) -> void:
	player.freeze = true
	player.position = global_position
	player.visible = false
	
	respawning_player = player
	sprite.play(&"open")	

func _on_body_entered(body:Node2D) -> void:
	if body is Player: register_checkpoint(body)

func _on_animation_finished() -> void:
	if sprite.animation == &"open":
		respawning_player.freeze = false
		respawning_player.velocity = Vector2.ZERO
		respawning_player.sprite.play(&"Idle")
		respawning_player.visible = true
		
	if sprite.animation == &"close" :
		sprite.play(&"default")
