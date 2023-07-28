extends Control


onready var nextLevel 

signal loadLevel

onready var mainMenu = get_node("/root/Game/GuiSafeArea/MainMenu")


# loads next Level
func _on_NextLevelButton_pressed():
	Sounds.play_sound("click","Sfx")
	get_node("/root/Game/Levels").get_child(0).queue_free()
	load_next_level(nextLevel)
	get_parent().reset_level_state()


func _on_MenuButton_pressed():
	Sounds.play_sound("click","Sfx")
	mainMenu.show()
	mainMenu._on_StartMenuBackButton_pressed()
	get_node("/root/Game/Levels").get_child(0).queue_free()
	get_parent().reset_all_states()

func load_next_level(nextLevel):
	get_node("/root/Game/Levels").get_child(0).queue_free()
	connect("loadLevel",get_node("/root/Game"),"_on_MainMenu_loadLevel",[],CONNECT_ONESHOT)
	emit_signal("loadLevel",GameResources.levelScenesDict.keys()[nextLevel])
	hide()
