extends Control


onready var inGameMenu = $InGameMenuControl/InGameMenuVBox
onready var optionsMenu = $InGameMenuControl/OptionsMenuVBox
onready var musicIcon = $InGameMenuControl/OptionsMenuVBox/MenuHBox/OptionsMenu/HBoxContainer/Icon
onready var ordersMenuButton = get_node("/root/Game/GuiSafeArea/LevelGui/OrdersMenuButton")
onready var cardMenu = get_node("/root/Game/GuiSafeArea/LevelGui/CardsMenu")
onready var cardsBackground = get_node("/root/Game/GuiSafeArea/LevelGui/CardsBackground")
onready var cardsGlobalBackground = get_node("/root/Game/Gui/CardsMenuBg")
onready var pointsTimerMenu = get_node("/root/Game/GuiSafeArea/LevelGui/PointsTimerMenu")
onready var background = get_node("/root/Game/Gui/BackgroundColorRect")
onready var mainMenu = get_node("/root/Game/GuiSafeArea/MainMenu")



signal stopTimer


func _on_ContinueGameButton_pressed():
	Sounds.play_sound("click","Sfx")
	hide()
	show_game_nodes()
	background.hide()
	get_tree().paused = false


func _on_OptinsButton_pressed():
	Sounds.play_sound("click","Sfx")
	inGameMenu.hide()
	optionsMenu.show()


func _on_CloseGameButton_pressed():
	Sounds.play_sound("click","Sfx")
	hide()
	mainMenu.show()
	mainMenu._on_StartMenuBackButton_pressed()
	get_node("/root/Game/Levels").get_child(0).queue_free()
	get_parent().reset_all_states()
	get_tree().paused = false


func _on_MusicButton_toggled(button_pressed):
	Sounds.play_sound("click","Sfx")
	if button_pressed:
		musicIcon.texture = GameResources.GuiTexturesDict["musicOff"]
		AudioServer.set_bus_mute(0,true)
	else:
		musicIcon.texture = GameResources.GuiTexturesDict["musicOn"]
		AudioServer.set_bus_mute(0,false)


func _on_OptionsBackToMenuButton_pressed():
	Sounds.play_sound("click","Sfx")
	optionsMenu.hide()
	inGameMenu.show()


func _on_IngameMenuButton_pressed():
	Sounds.play_sound("click","Sfx")
	hide_game_nodes()
	get_tree().paused = true
	background.show()
	show()

func hide_game_nodes():
	ordersMenuButton.hide()
	cardMenu.hide()
	pointsTimerMenu.hide()
	cardsBackground.hide()
	cardsGlobalBackground.hide()
func show_game_nodes():
	ordersMenuButton.show()
	cardMenu.show()
	pointsTimerMenu.show()
	cardsBackground.show()
	cardsGlobalBackground.show()
