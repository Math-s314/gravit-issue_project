
extends Camera2D

@export var player: CharacterBody2D  # glisse ton joueur dans l'inspecteur
@export var max_offset := 150.0      # combien la caméra anticipe en pixels
@export var follow_speed := 2.0     # vitesse de lissage

func _process(delta):
	if not player:
		return
	
	# direction horizontale du joueur
	var dir_x := 0.0
	if player.velocity.x > 10:  # seuil vers la droite
		dir_x = 1.0
	elif player.velocity.x < -10:  # seuil vers la gauche
		dir_x = -1.0
	
	# position cible = joueur + offset selon direction
	var target_pos = player.global_position + Vector2(dir_x * max_offset, 0)
	
	# interpolation pour un mouvement fluide
	global_position = global_position.lerp(target_pos, follow_speed * delta)
