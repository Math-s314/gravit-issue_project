extends Control
class_name Hud

@onready var escape_menu := $PanelContainer
@onready var gear_label := $Panel/HBoxContainer/ControlLabel/Label
var escape := false
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func set_gears(value : int):
	gear_label.text = str(value)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		escape = !escape
		escape_menu.visible = escape
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if escape else Input.MOUSE_MODE_CAPTURED)
		
func _on_yes_pressed() -> void:
	GameInstance.switch_scene(0, ^"")

func _on_no_pressed() -> void:
	escape = false
	escape_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
