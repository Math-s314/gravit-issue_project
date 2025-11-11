extends Spawner
class_name CommandCenter

@onready var sprite := $AnimatedSprite2D
@onready var light := $PointLight2D
var respawning_player : Player = null

func _ready():
	if GameInstance.get_node_data(self) != true :
		sprite.play(&"initial")
		light.visible = false
	else:
		sprite.play(&"default")
		light.visible = true

func register_checkpoint(player : Player) -> void:
	var lvl : int = GameInstance.getLevelManager().level_number
	# Check if this checkpoint is the last unlocked
	if GameInstance.get_node_data(self) != true :
		# Lock previous one if it exists
		if player.last_checkpoint_lvl > 0:
			GameInstance._set_node_data(player.last_checkpoint_lvl, String(player.last_checkpoint_spa), false)
				
		if player.last_checkpoint_lvl == lvl :
			var old : CommandCenter = get_node(player.last_checkpoint_spa)
			old.sprite.play(&"reset")
			
		# Lock this one
		GameInstance.set_node_data(self, true)
		light.visible = true
		sprite.play(&"close")
		
	# Save state (even if the CommandCenter was already unlocked)
	# TODO : Add feedback to this effect !!
	player.last_checkpoint_lvl = lvl
	player.last_checkpoint_spa = get_path()
	
	var save_file := FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var save_dict := {
		"game_instance" : GameInstance.nodes,
		"player" : {
			"last_checkpoint_spa" : player.last_checkpoint_spa,
			"last_checkpoint_lvl" : player.last_checkpoint_lvl
		}
	}
	save_file.store_line(JSON.stringify(save_dict))
	
func spawn_player(player : Player) -> void:
	player.freeze = true
	player.position = global_position
	player.visible = false
	
	respawning_player = player
	sprite.play(&"open")	

func _on_body_entered(body:Node2D) -> void:
	if body is Player: register_checkpoint(body as Player)

func _on_animation_finished() -> void:
	if sprite.animation == &"open":
		sprite.play(&"respawn")
		
	elif sprite.animation == &"respawn":
		respawning_player.freeze = false
		respawning_player.velocity = Vector2.ZERO
		respawning_player.sprite.play(&"Idle")
		respawning_player.visible = true
		sprite.play(&"close")
	
	elif sprite.animation == &"close":
		sprite.play(&"default")
		
	elif sprite.animation == &"reset":
		light.visible = false
		sprite.play(&"initial")
