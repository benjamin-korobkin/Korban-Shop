extends Node2D

onready var randNumGenerator = RandomNumberGenerator.new()
onready var animatedSprite = $AnimatedSprite
onready var tween = $Tween
onready var appearDisappearTween = $AppearDisappearTween
onready var answerSprite = $AnswerSprite
onready var guiTween = $AnswerSprite/GuiTween
onready var pointsTimer = $PointsTimer
onready var waitingPos 
onready var positionName 
onready var cardNodePath 

onready var orderDict : Dictionary
onready var occasion : String
onready var category : String

const ZERO : int = 0
const MINUS_POINTS : int = -200
const CORRECT_ORDER_POINTS : int = 100

onready var decreaseScore : bool = false

var originalTimeLeft : int = 60
onready var pointsCalculationDict : Dictionary = {
	"perfect" : 1.0,
	"good" : 1.0,
	"nice" : 1.0,
	"bad" : 1.0,
}
var points : int = ZERO
#var successiveOrdersDone = 0

signal spawn_card
signal handleHighlights
signal handleCardHighlights
signal showCard
signal spawnCustomer
signal addPoints
signal handleCompleteOrderButton


onready var orderCompleted : bool = false
onready var walkingTowardsStartingPoint : bool = true
onready var levelNode = get_node("/root/Game/Levels").get_child(0)
onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")
onready var pointsTimerMenuNode = get_node("/root/Game/GuiSafeArea/LevelGui/PointsTimerMenu")
onready var highlightButton = $HighlightButton
signal handleOrdersMenuButton

func _ready():
	randomize()
	connect("spawn_card",get_node("/root/Game/GuiSafeArea/LevelGui/CardsMenu"),"spawn_card")
	connect("handleHighlights",get_parent(),"handle_highlights")
	apply_texture()
	create_card(category,occasion,orderDict,self)
	move_to_pos()
	yield(get_tree(),"idle_frame")
	connect("handleCardHighlights",cardNodePath,"add_highlight")
	connect("showCard",cardNodePath,"show")
	connect("spawnCustomer",levelNode,"spawn_customer")
	connect("handleOrdersMenuButton",levelGui,"handle_orders_menu_button")
	connect("addPoints",pointsTimerMenuNode,"add_points")
	
#applies random customer texture from animatedsprite
func apply_texture():
	randNumGenerator.randomize()
	animatedSprite.animation = "male"
	var randomTexture = randNumGenerator.randi_range(0,animatedSprite.frames.get_frame_count("male") -1)
	animatedSprite.frame = randomTexture

#gets order from level node.
func get_order(order):
	orderDict = order[2].duplicate(true)
	occasion = order[1]
	category = order[0]

#creates a card when customer is created, passes all the order dictionary to it using a signal.
func create_card(category,occasion,KorbanotDict,customerPath):
	emit_signal("spawn_card",category,occasion,KorbanotDict,customerPath)


#sets position to go to
func set_pos(openPos):
	waitingPos = openPos[0]
	positionName = openPos[1]

#move to the wating position from spawn position
func move_to_pos():
	appearDisappearTween.interpolate_property(self,"modulate",Color(1,1,1,0),Color(1,1,1,1),1,Tween.TRANS_CUBIC,Tween.EASE_IN)
	appearDisappearTween.start()
	tween.interpolate_property(self,"position",position,waitingPos,3,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()

#highlights the customer when clicked
var highlighted : bool = false

func _on_HighlightButton_pressed():
	if !highlighted:
		Sounds.play_sound("click","Sfx")
		emit_signal("handleHighlights",self)
		emit_signal("handleCardHighlights")
		connect("handleCompleteOrderButton",levelGui,"handle_complete_order",[],CONNECT_ONESHOT)
		emit_signal("handleCompleteOrderButton",false)
		connect("handleOrdersMenuButton",levelGui,"handle_orders_menu",[],CONNECT_ONESHOT)
		emit_signal("handleOrdersMenuButton",false)
		highlighted = true
		$AnimationPlayer.play("highlight")
		tween.interpolate_property(self,"position",position,levelNode.customerOrderPos,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.start()

#removes highloght.
func remove_highlight():
	highlighted = false
	$AnimationPlayer.play("RESET")
	if !orderCompleted and !walkingTowardsStartingPoint and position != waitingPos:
		tween.interpolate_property(self,"position",position,waitingPos,1,Tween.TRANS_LINEAR,Tween.EASE_IN)
		tween.start()

#checks if order complete, then queues free, else shows card.
func _on_Tween_tween_completed(object, key):
	if orderCompleted:
		queue_free()
	else:
		if !cardNodePath.visible:
			pointsTimer.start(originalTimeLeft)
			emit_signal("showCard")
			walkingTowardsStartingPoint = false
			highlightButton.disabled = false

#checks order condition and applying the right gui + changes orderCompelted bool, then displaying gui.
signal handleBoxSprite
signal eraseOrderFromCurrentOrders

#signal to player node to hide or show box depending if order complete
func check_order_condition(isOrderComplete):
	if isOrderComplete:
		orderCompleted = true
		answerSprite.texture = GameResources.GuiTexturesDict["checkMark"]
		Sounds.play_sound("confirmation","Sfx2")
		connect("eraseOrderFromCurrentOrders",get_node("/root/Game/Levels").get_child(0),"remove_order_from_array",[],CONNECT_ONESHOT)
		emit_signal("eraseOrderFromCurrentOrders",[category,occasion])
		connect("handleBoxSprite",get_node("/root/Game/Levels").get_child(0),"handle_box_sprite",[],CONNECT_ONESHOT)
		emit_signal("handleBoxSprite",true)
		connect("handleCompleteOrderButton",levelGui,"handle_complete_order",[],CONNECT_ONESHOT)
		emit_signal("handleCompleteOrderButton",true)
		connect("handleOrdersMenuButton",levelGui,"handle_orders_menu",[],CONNECT_ONESHOT)
		emit_signal("handleOrdersMenuButton",true)
		$AnimatedSprite/Box.show()
	else:
		answerSprite.texture = GameResources.GuiTexturesDict["cross"]
		connect("handleBoxSprite",get_node("/root/Game/Levels").get_child(0),"handle_box_sprite",[],CONNECT_ONESHOT)
		emit_signal("handleBoxSprite",false)
		Sounds.play_sound("error","Sfx2")
		emit_signal("handleOrdersMenuButton",false)
		emit_signal("addPoints",MINUS_POINTS)
	display_gui()

#displays gui
func display_gui():
	guiTween.interpolate_property(answerSprite,"scale",Vector2(0,0),Vector2(1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	guiTween.start()

#displays gui, or activates walk_out_of_bounds()
func _on_GuiTween_tween_completed(object, key):

	#emit_signal("handleOrdersMenuButton",false)
	if answerSprite.scale == Vector2(1,1):
		guiTween.interpolate_property(answerSprite,"scale",Vector2(1,1),Vector2(0,0),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
		guiTween.start()
	if answerSprite.scale.floor() == Vector2(0,0) and orderCompleted:
		walk_out_of_bounds()

#walks customer out of bounds, opening it's position in the level and queues him free once reached the destionation.
func walk_out_of_bounds():
	levelNode.openPositions[positionName]["open"] = true
	var outOfBoundsPosition = levelNode.outOfBoundsPositions
	var randomNum = randNumGenerator.randi_range(0,1)
	appearDisappearTween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),3.0,Tween.TRANS_CUBIC,Tween.EASE_IN)
	appearDisappearTween.start()
	tween.interpolate_property(self,"position",position,outOfBoundsPosition[outOfBoundsPosition.keys()[randomNum]],5.0,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	calculate_points()
	emit_signal("spawnCustomer")


func calculate_points():
	if decreaseScore:
		points = ZERO
	else:
		points = CORRECT_ORDER_POINTS
	emit_signal("addPoints",points)

func activate_score_decrease():
	decreaseScore = true


# Formerly part of calculate_points()
#if pointsTimer.time_left < originalTimeLeft * pointsCalculationDict["bad"]:
#		points = CORRECT_ORDER_POINTS * pointsCalculationDict["bad"]
#	elif pointsTimer.time_left <= originalTimeLeft * pointsCalculationDict["nice"]:
#		points = CORRECT_ORDER_POINTS * pointsCalculationDict["nice"]
#	elif pointsTimer.time_left <= originalTimeLeft * pointsCalculationDict["good"] :
#		points = CORRECT_ORDER_POINTS * pointsCalculationDict["good"]
#	elif pointsTimer.time_left >= originalTimeLeft:
#		points = CORRECT_ORDER_POINTS * pointsCalculationDict["perfect"]
