extends Control



onready var mainMenu = get_node("/root/Game/GuiSafeArea/MainMenu")


func _on_MenuButton_pressed():
	Sounds.play_sound("click","Sfx")
	mainMenu.show()
	mainMenu._on_StartMenuBackButton_pressed()
	get_node("/root/Game/Levels").get_child(0).queue_free()
	get_parent().reset_all_states()
	
