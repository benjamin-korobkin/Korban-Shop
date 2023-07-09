extends Control

onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")
onready var ordersMenuButton = get_node("/root/Game/GuiSafeArea/LevelGui/OrdersMenuButton")
onready var completeOrderButton = get_node("/root/Game/GuiSafeArea/LevelGui/OrdersMenu/OrdersManager/CompleteOrder/CompleteOrderButton")




#func _input(event):
#	if event.is_action_pressed("ui_up"):
#		Engine.time_scale = 5
#	if event.is_action_pressed("ui_down"):
#		Engine.time_scale = 1

#click to advance to card_first_display()
func click_on_cutsomer():
	$ClickOnCustomer.show()
	$ClickOnCustomer/AnimationPlayer.play("click")


func card_first_display():
	$ClickOnCustomer.hide()
	$ClickOnCustomer/AnimationPlayer.stop()
	$CardFirstDisplay.show()

func _on_CardFirstDisplayButton_pressed():
	Sounds.play_sound("click","Sfx")
	card_exp_1()


func card_exp_1():
	$CardFirstDisplay.hide()
	$CardExplanation.show()

	
func _on_CardExplanationButton_pressed():
	Sounds.play_sound("click","Sfx")
	card_exp_2()

func card_exp_2():
	$CardExplanation.hide()
	$CardExplanation2.show()

func _on_CardExplanation2Button_pressed():
	Sounds.play_sound("click","Sfx")
	card_exp_3()

func card_exp_3():
	$CardExplanation2.hide()
	$CardExplanation3.show()

func _on_CardExplanation3Button_pressed():
	Sounds.play_sound("click","Sfx")
	card_exp_4()

func card_exp_4():
	$CardExplanation3.hide()
	$CardExplanation4.show()

func _on_CardExplanation4Button_pressed():
	Sounds.play_sound("click","Sfx")
	card_exp_5()

#click to advance to card_exp_6() 
signal enableCardButton
func card_exp_5():
	$CardExplanation4.hide()
	$CardExplanation5.show()
	$CardExplanation5/AnimationPlayer.play("click")
	connect("enableCardButton",get_parent().get_node("CardsMenu").get_child(0),"enable_button",[],CONNECT_ONESHOT)
	emit_signal("enableCardButton")


func card_exp_6():
	$CardExplanation5/AnimationPlayer.stop()
	$CardExplanation5.hide()
	yield(get_tree().create_timer(2),"timeout")
	$CardExplanation6.show()

func _on_CardExplanation6Button_pressed():
	Sounds.play_sound("click","Sfx")
	shop_exp_1()


func shop_exp_1():
	$CardExplanation6.hide()
	$ShopExplanation.show()
	ordersMenuButton.disabled = false
	$ShopExplanation/AnimationPlayer.play("click")



func shop_exp_2():
	$ShopExplanation/AnimationPlayer.stop()
	$ShopExplanation.hide()
	$ShopExplanation2.show()
	$ShopExplanation2/AnimationPlayer.play("click")

func shop_exp_3():
	$ShopExplanation2/AnimationPlayer.stop()
	$ShopExplanation2.hide()
	$ShopExplanation3.show()

func _on_ShopExplanation3Button_pressed():
	Sounds.play_sound("click","Sfx")
	shop_exp_4()

signal handleCompleteOrder
#handleCompleteOrder signals with boolean that affects .disabled, so false is not disabled ture is disabled
func shop_exp_4():
	connect("handleCompleteOrder",levelGui,"handle_complete_order",[],CONNECT_ONESHOT)
	emit_signal("handleCompleteOrder",false)
	connect("handleOrdersMenu",levelGui,"handle_orders_menu",[],CONNECT_ONESHOT)
	emit_signal("handleOrdersMenu",false)
	$ShopExplanation3.hide()
	$ShopExplanation4.show()
	$ShopExplanation4/AnimationPlayer.play("click")


func gui_exp_1():
	$ShopExplanation4.hide()
	$GuiExplanation.show()
	$GuiExplanation/AnimationPlayer.play("blink")

func _on_GuiExplanationButton_pressed():
	Sounds.play_sound("click","Sfx")
	$GuiExplanation/AnimationPlayer.stop()
	gui_exp_2()


func gui_exp_2():
	$GuiExplanation.hide()
	$GuiExplanation2.show()
	$GuiExplanation2/AnimationPlayer.play("blink")

func _on_GuiExplanation2Button_pressed():
	Sounds.play_sound("click","Sfx")
	$GuiExplanation2/AnimationPlayer.stop()
	$GuiExplanation2.hide()
	get_tree().paused = false
	queue_free()






















