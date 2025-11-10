extends TextureRect

@export var center: Vector2
@export var radius_x: float 
@export var radius_y: float
@export var speed: float

var angle : float = PI
var width : float

func _ready() -> void:
	width = anchor_right - anchor_left

func _process(delta):
	angle += speed * delta
	var x := center.x + cos(angle) * radius_x
	anchor_left = x - width/2
	anchor_right = x + width/2
	
	var y := center.y + sin(angle) * radius_y
	anchor_top = y
	anchor_bottom = y
