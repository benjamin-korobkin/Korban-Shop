extends Control

onready var orderDict : Dictionary


onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")
onready var cardsMenu = get_node("/root/Game/GuiSafeArea/LevelGui/CardsMenu")

onready var focusedButton : String

signal compareOrder
signal movePlayerToOrderCounter
signal handleOrdersMenuButton

func _ready():
	yield(get_tree(),"idle_frame")
	connect("handleOrdersMenuButton",levelGui,"handle_orders_menu_button")

#activates seller animation and passes order dictionary.
var tutorialClicked2 : bool = false
signal guiExp1
func _on_OrdersManager_completeOrder(dict):
	Sounds.play_sound("click","Sfx")
	var order = dict.duplicate(true)
	var levelNode = get_node("/root/Game/Levels").get_child(0)
	hide()
	if !is_connected("movePlayerToOrderCounter",levelNode,"move_player_to_order_counter"):
		connect("movePlayerToOrderCounter",levelNode,"move_player_to_order_counter")
	emit_signal("movePlayerToOrderCounter",order)
	emit_signal("handleOrdersMenuButton",true)
	if get_node("/root/Game/Levels").get_child(0).name == "Tutorial":
		if !tutorialClicked2:
			tutorialClicked2 = true
			connect("guiExp1",levelGui.get_node("TutorialGui"),"gui_exp_1",[],CONNECT_ONESHOT)
			emit_signal("guiExp1")
