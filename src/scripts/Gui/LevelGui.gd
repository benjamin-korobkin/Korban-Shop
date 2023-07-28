extends Control





onready var ordersMenu = $OrdersMenu
onready var ordersMenuButton = $OrdersMenuButton
onready var background = get_node("/root/Game/Gui/BackgroundColorRect")
onready var cardsMenuBg = get_node("/root/Game/Gui/CardsMenuBg")




func _on_Game_handleLevelGui(show):
	if show:
		show()
	else:
		hide()

var tutorialClicked : bool = false
signal shopExp2

func _on_OrdersMenuButton_pressed():
	Sounds.play_sound("click","Sfx")
	if !ordersMenu.visible:
		ordersMenu.show()
	else:
		ordersMenu.hide()
	if get_node("/root/Game/Levels").get_child(0).name == "Tutorial":
		if !tutorialClicked:
			tutorialClicked = true
			connect("shopExp2",get_node("TutorialGui"),"shop_exp_2")
			emit_signal("shopExp2")



func handle_orders_menu_button(disable):
	ordersMenuButton.disabled = disable

# when pressing close game in the ingame menu, reset all gui states.
func reset_all_states():
	background.show()
	cardsMenuBg.hide()
	for child in $CardsMenu.get_children():
		child.queue_free()
	for position in $CardsMenu.openPositions.size():
		$CardsMenu.openPositions[$CardsMenu.openPositions.keys()[position]]["open"] = true
	$PointsTimerMenu.set_physics_process(false)
	$PointsTimerMenu.pointsTweenActive = false
	$CardsMenu.show()
	$PointsTimerMenu.show()
	$OrdersMenu.hide()
	$OrdersMenuButton.show()
	$LevelCompletedMenu.hide()
	$LevelFailedMenu.hide()
	$OrdersMenu.tutorialClicked2 = false
	$OrdersMenu.get_node("OrdersManager/Kid").tutorialPressed = false
	tutorialClicked = false
	hide()
	get_tree().paused = false

#displays level complete or failed gui if true, level completed, else level failed, also unlocks levels.
func display_gui(levelComleted,levelName):
	get_tree().paused = true
	if levelComleted:
		if levelName == "Level 8":
			$GameCompletedMenu.show()
		else:
			$LevelCompletedMenu.nextLevel =  unlock_level(levelName)
			$LevelCompletedMenu.show()
	else:
		$LevelFailedMenu.level = levelName
		$LevelFailedMenu.show()


func reset_level_state():
	for child in $CardsMenu.get_children():
		child.queue_free()
	for position in $CardsMenu.openPositions.size():
		$CardsMenu.openPositions[$CardsMenu.openPositions.keys()[position]]["open"] = true
	get_tree().paused = false

func unlock_level(levelName):
	var levelsDict = GameResources.levelScenesDict.keys()
	var nextLevel
	for level in levelsDict.size() - 1:
		if levelsDict[level] == levelName:
			nextLevel = level + 1
			break
	GameStateService.add_data(GameStateService.globalData.keys()[nextLevel],true)
	return nextLevel

func handle_shop_buttons(levelName):
	if levelName != "Tutorial":
		$OrdersMenuButton.disabled = true
		$OrdersMenu/OrdersManager/CompleteOrder/CompleteOrderButton.disabled = true
	else:
		$OrdersMenuButton.disabled = true
		$OrdersMenu/OrdersManager/CompleteOrder/CompleteOrderButton.disabled = true

func handle_complete_order(enable):
	$OrdersMenu/OrdersManager/CompleteOrder/CompleteOrderButton.disabled = enable

func handle_orders_menu(enable):
	$OrdersMenuButton.disabled = enable
