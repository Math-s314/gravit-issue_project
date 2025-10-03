extends Area2D

@export var connected_objects: Array

signal activate

func _ready() -> void:
	for elem in connected_objects:
		activate.connect(elem.change_state)
	
	

func _on_body_entered(body:Node2D) -> void:
	if body is Player :
		activate.emit()
