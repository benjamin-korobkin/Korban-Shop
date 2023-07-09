extends HBoxContainer


onready var ordersManager = get_parent()
onready var amountLabel = get_child(2).get_child(0)
onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")
onready var levelsNode = get_node("/root/Game/Levels")

func _on_MinusButton_pressed():
	Sounds.play_sound("click","Sfx")
	if ordersManager.orderAmountDict[name] != 0:
		ordersManager.change_amount(name,-1)
		amountLabel.text = str(ordersManager.orderAmountDict[name])
		

signal shopExp3
var tutorialPressed : bool = false
func _on_PlusButton_pressed():
	Sounds.play_sound("click","Sfx")
	if ordersManager.orderAmountDict[name] != 20:
		ordersManager.change_amount(name,1)
		amountLabel.text = str(ordersManager.orderAmountDict[name])
	if levelsNode.get_child(0).name == "Tutorial" and !tutorialPressed:
		tutorialPressed = true
		connect("shopExp3",levelGui.get_node("TutorialGui"),"shop_exp_3",[],CONNECT_ONESHOT)
		emit_signal("shopExp3")



func _on_OrdersManager_resetAll():
	amountLabel.text = str(0)
