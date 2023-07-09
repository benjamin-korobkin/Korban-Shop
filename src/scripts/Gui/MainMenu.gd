extends Control


signal loadLevel


onready var mainMenu = $MainMenuControl/MainMenuVBox
onready var startGameMenu = $MainMenuControl/StartGameMenuVBox
onready var levelSelectionButtons : Array = [
	$MainMenuControl/StartGameMenuVBox/StartGameMenuHBox/StartGameMenu/LevelSelectionButton,
	$MainMenuControl/StartGameMenuVBox/StartGameMenuHBox/StartGameMenu/LevelSelectionButton2,
	$MainMenuControl/StartGameMenuVBox/StartGameMenuHBox/StartGameMenu/LevelSelectionButton3,
]
onready var startGameMenuLeftButton = $MainMenuControl/StartGameMenuVBox/StartGameMenuHBox/StartGameMenu/ArrowButtonsHBox/LeftButton
onready var startGameMenuRightButton = $MainMenuControl/StartGameMenuVBox/StartGameMenuHBox/StartGameMenu/ArrowButtonsHBox/RightButton
onready var startGameMenuLastPageMargin = $MainMenuControl/StartGameMenuVBox/StartGameMenuHBox/StartGameMenu/MarginContainer4
onready var optionsMenu = $MainMenuControl/OptionsMenuVBox
onready var musicIcon = $MainMenuControl/OptionsMenuVBox/MenuHBox/OptionsMenu/HBoxContainer/Icon

var startMenuPage = 1




func load_data():
	startMenuPage = GameStateService.globalData["startMenuPage"]


func _ready():
	load_data()
	initialize_startGameMenu(startMenuPage)

#Main menu
#------------------------------------------
#hides main menu, shows start menu, locks or unlockes buttons
func _on_StartGameButton_pressed():
	Sounds.play_sound("click","Sfx")
	initialize_startGameMenu(startMenuPage)
	mainMenu.hide()
	startGameMenu.show()
#------------------------------------------
#Start game menu
#------------------------------------------
#hides start menu, shows main menu
func _on_StartMenuBackButton_pressed():
	Sounds.play_sound("click","Sfx")
	startGameMenu.hide()
	mainMenu.show()

#hides main menu, shows options menu
func _on_OptinsButton_pressed():
	Sounds.play_sound("click","Sfx")
	mainMenu.hide()
	optionsMenu.show()

#Exits Game
func _on_Exit_Game_pressed():
	Sounds.play_sound("click","Sfx")
	GameStateService.save_data()
	get_tree().quit()

#------------------------------------------

#------------------------------------------
#Options Menu
#------------------------------------------
#mutes master bus and changes icon
func _on_MusicButton_toggled(button_pressed):
	Sounds.play_sound("click","Sfx")
	if button_pressed:
		musicIcon.texture = GameResources.GuiTexturesDict["musicOff"]
		AudioServer.set_bus_mute(0,true)
	else:
		musicIcon.texture = GameResources.GuiTexturesDict["musicOn"]
		AudioServer.set_bus_mute(0,false)

#hides options menu, shows main menu
func _on_OptionsBackToMenuButton_pressed():
	Sounds.play_sound("click","Sfx")
	optionsMenu.hide()
	mainMenu.show()
#------------------------------------------
#Credits Button
func _on_CreditsButton_pressed():
	Sounds.play_sound("click","Sfx")
	var creditsRsc = GameResources.scenesDict["creditsScene"].instance()
	add_child(creditsRsc)
#------------------------------------------
#moves the start menu page forwads
func _on_LeftButton_pressed():
	Sounds.play_sound("click","Sfx")
	if startMenuPage != 1:
		startMenuPage -=1
		initialize_startGameMenu(startMenuPage)

#moves the start menu page backwards
func _on_RightButton_pressed():
	Sounds.play_sound("click","Sfx")
	if startMenuPage != 4:
		startMenuPage +=1
		initialize_startGameMenu(startMenuPage)

#sets the right text for the buttons, called at ready and by left and right button.
func initialize_startGameMenu(_startMenuPage):
	GameStateService.add_data("startMenuPage",_startMenuPage)
	handle_startGameMenu_buttons(_startMenuPage)
	handle_level_selection_buttons(_startMenuPage)
	for selectionButton in levelSelectionButtons.size():
		levelSelectionButtons[selectionButton].text = GameResources.startGameLevelTextDict[_startMenuPage][selectionButton]

#disables or enables the page buttons called from initialize_startGameMenu
func handle_startGameMenu_buttons(_startMenuPage):
	if _startMenuPage != 1:
		startGameMenuLeftButton.disabled = false
	else:
		startGameMenuLeftButton.disabled = true
	if _startMenuPage != 4:
		startGameMenuRightButton.disabled = false
	else:
		startGameMenuRightButton.disabled = true

#disables or enables levels depending on save data
func handle_level_selection_buttons(_startMenuPage):
	for button in levelSelectionButtons.size():
		if GameResources.startGameLevelTextDict[_startMenuPage].has(button):
			var buttonName = GameResources.startGameLevelTextDict[_startMenuPage][button]
			if GameStateService.globalData.has(buttonName) and GameStateService.globalData[buttonName] == true:
				levelSelectionButtons[button].disabled = false
			else:
				levelSelectionButtons[button].disabled = true

#loads levels based on button text
func _on_LevelSelectionButton_pressed():
	Sounds.play_sound("click","Sfx")
	var levelName = levelSelectionButtons[0].text
	emit_signal("loadLevel",levelName)

#loads levels based on button text
func _on_LevelSelectionButton2_pressed():
	Sounds.play_sound("click","Sfx")
	var levelName = levelSelectionButtons[1].text
	emit_signal("loadLevel",levelName)

#loads levels based on button text
func _on_LevelSelectionButton3_pressed():
	Sounds.play_sound("click","Sfx")
	var levelName = levelSelectionButtons[2].text
	emit_signal("loadLevel",levelName)
#------------------------------------------

#hides or shows node
func _on_Game_handleMainMenu(show):
	if show:
		show()
	else:
		hide()



