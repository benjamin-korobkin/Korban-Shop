extends Control

onready var level

onready var retryButton = $Background/RetryButton
onready var menuButton = $Background/MenuButton
onready var mainMenu = get_node("/root/Game/GuiSafeArea/MainMenu")

signal loadLevel

func _on_RetryButton_pressed():
	Sounds.play_sound("click","Sfx")
	get_node("/root/Game/Levels").get_child(0).queue_free()
	yield(get_tree(),"idle_frame")
	get_parent().reset_level_state()
	load_level(level)


func _on_MenuButton_pressed():
	Sounds.play_sound("click","Sfx")
	mainMenu.show()
	mainMenu._on_StartMenuBackButton_pressed()
	get_node("/root/Game/Levels").get_child(0).queue_free()
	get_parent().reset_all_states()


func load_level(level):
	connect("loadLevel",get_node("/root/Game"),"_on_MainMenu_loadLevel",[],CONNECT_ONESHOT)
	emit_signal("loadLevel",level)
	hide()
