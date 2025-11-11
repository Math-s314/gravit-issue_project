extends Area2D
class_name Lever

signal activate
signal deactivate

@export var stay_in_place : bool = true

@onready var sprite := $Sprite2D
@onready var area := $CollisionShape2D
@onready var block := $StaticBody2D/CollisionShape2D

## State
var activated : bool = false
var num_inside : int = 0

func _ready() -> void:
	activated = (GameInstance.get_node_data(self) == true)
	if activated :
		sprite.frame = 1
		area.position.y = -20.0
		block.position.y = 35.0

func check_body(body: Node2D) -> bool:
	return body is Player
	
func activate_scene() -> void:
	GameInstance.set_node_data(self, true)
	activated = true
	sprite.frame = 1
	area.position.y = -20.0
	block.position.y = 35.0
	activate.emit()
	
func deactivate_scene() -> void:
	GameInstance.set_node_data(self, false)
	activated = false
	sprite.frame = 0
	area.position.y = -40.0
	block.position.y = 14.0
	deactivate.emit()

func _on_body_entered(body:Node2D) -> void:
	if check_body(body) :
		num_inside += 1
		if num_inside == 1 && !activated : 
			activate_scene()
			print("Coucou")
	
func _on_body_exited(body:Node2D) -> void:
	if check_body(body) :
		num_inside -= 1
		if num_inside == 0 && activated && !stay_in_place : deactivate_scene()
	
