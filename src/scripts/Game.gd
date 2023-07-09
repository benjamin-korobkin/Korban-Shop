extends Control

# parent node of all game nodes besides singletons, controls the flow of the game.

signal handleMainMenu(show)
signal handleMainMenuBg(show)
signal handleLevelGui(show)
signal handleCardsMenuBg(show)

onready var guiSafeArea = $GuiSafeArea
onready var mainMenu = $GuiSafeArea/MainMenu
onready var levelGui = $GuiSafeArea/LevelGui
onready var inGameMenu = $GuiSafeArea/LevelGui/InGameMenu
onready var ordersMenu = $GuiSafeArea/LevelGui/OrdersMenu
onready var levelsNode = $Levels



func _on_MainMenu_loadLevel(level):
	var levelRsc = GameResources.levelScenesDict[level].instance()
	levelsNode.add_child(levelRsc)
	handle_gui(true,false,false,true)

#handles all gui when loading a level.
func handle_gui(_levelGui : bool,_mainMenu : bool,_Bg : bool,_topBg):
	emit_signal("handleLevelGui",_levelGui)
	emit_signal("handleMainMenu",_mainMenu)
	emit_signal("handleMainMenuBg",_Bg)
	emit_signal("handleCardsMenuBg",_topBg)

#handles safe area for all sizes, anchoring GuiSafeArea and it's children
func _on_Game_tree_entered():
	var safeArea = OS.get_window_safe_area()
	var screenSize = get_viewport().get_visible_rect().size
	var leftMargin = safeArea.position / (screenSize - safeArea.position)
	for guiNode in $GuiSafeArea.get_children():
		if guiNode.name == "Tween" or guiNode.name == "BackgroundColorRect":
			pass
		else:
			guiNode.set_anchor(MARGIN_LEFT,leftMargin.x)
			guiNode.set_anchor(MARGIN_TOP,leftMargin.y)


func _on_Sounds_tree_entered():
	Sounds.soundsNode = $Sounds
