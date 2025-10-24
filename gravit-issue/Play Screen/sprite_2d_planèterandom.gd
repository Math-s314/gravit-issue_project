extends Sprite2D

@export var center: Vector2 = Vector2(0,700) # centre de l'ellipse
@export var radius_x: float = 2000       # rayon horizontal
@export var radius_y: float = 800         # rayon vertical
@export var speed: float = 0.25          # vitesse de rotation (radians/sec)

var angle: float = PI/2

func _process(delta):
	angle += speed * delta
	position.x = center.x + cos(angle) * radius_x
	position.y = center.y + sin(angle) * radius_y
