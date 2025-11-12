extends LevelManager
class_name Menu

@onready var but_play := $HBoxContainer/Play
@onready var but_cont := $HBoxContainer/Continue
@onready var but_cred := $HBoxContainer/Credit
@onready var but_quit := $HBoxContainer/Quit
@onready var but_back := $HBoxContainer/Back
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var title := $Title

var save_exists := false

func _ready() -> void:
	save_exists = FileAccess.file_exists("user://savegame.save")
	but_cont.visible = save_exists

func _on_play_pressed() -> void:
	player = GameInstance.player_scene.instantiate()
	player.last_checkpoint_spa = ^"/root/level1/CommandCenter"
	player.last_checkpoint_lvl = 1
	
	GameInstance.nodes = [{}, {}, {}, {}, {}, {}, {}, {}, {}] as Array[Dictionary]
	GameInstance._set_node_data(1, "/root/level1/CommandCenter", true)
	GameInstance.switch_scene(1, ^"/root/level1/CommandCenter") 
	anim.play(&"fade_out")
	

func _on_continue_pressed() -> void:
	player = GameInstance.player_scene.instantiate()
	
	var save_file := FileAccess.open("user://savegame.save", FileAccess.READ)
	var json = JSON.new()
	json.parse(save_file.get_line())
	
	player.last_checkpoint_spa = json.data.player.last_checkpoint_spa
	player.last_checkpoint_lvl = json.data.player.last_checkpoint_lvl
	player.gears_collected = json.data.player.gears_collected
	
	for i in range(json.data.game_instance.size()):
		GameInstance.nodes[i] = json.data.game_instance[i]
	GameInstance.switch_scene(player.last_checkpoint_lvl, player.last_checkpoint_spa)

func _on_credit_pressed() -> void:
	title.visible = false
	but_play.visible = false
	but_cont.visible = false
	but_cred.visible = false
	but_quit.visible = false
	but_back.visible = true
	
func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_back_pressed() -> void:
	title.visible = false
	but_play.visible = true
	but_cont.visible = save_exists
	but_cred.visible = true
	but_quit.visible = true
	but_back.visible = false
