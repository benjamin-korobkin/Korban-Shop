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


var originalTimeLeft : int = 60
onready var pointsCalculationDict : Dictionary = {
	"perfect" : 1.0,
	"good" : 1.0,
	"nice" : 1.0,
	"bad" : 1.0,
}
var CORRECT_ORDER_POINTS : int = 100
var points : int = 0

signal clickOnCutsomer

signal spawn_card
signal handleHighlights
signal handleCardHighlights
signal showCard
signal spawnCustomer
signal addPoints

onready var orderCompleted : bool = false
onready var walkingTowardsStartingPoint : bool = true
onready var levelNode = get_node("/root/Game/Levels").get_child(0)
onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")
onready var pointsTimerMenuNode = get_node("/root/Game/GuiSafeArea/LevelGui/PointsTimerMenu")
onready var highlightButton = $HighlightButton
signal handleOrdersMenuButton

func _ready():
	randomize()
	connect("spawn_card",get_node("/root/Game/GuiSafeArea/LevelGui/CardsMenu"),"spawn_tutorial_card")
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

#applies random texture from animatedsprite
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
var clickedOnce : bool = false
signal cardFirstDisplay
func _on_HighlightButton_pressed():
	if !highlighted and !clickedOnce:
		clickedOnce = true
		connect("cardFirstDisplay",levelGui.get_node("TutorialGui"),"card_first_display",[],CONNECT_ONESHOT)
		emit_signal("cardFirstDisplay")
		Sounds.play_sound("click","Sfx")
		emit_signal("handleHighlights",self)
		emit_signal("handleCardHighlights")
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

#checks if order compelete, then queues free, else shows card.
func _on_Tween_tween_completed(object, key):
	if orderCompleted:
		queue_free()
	else:
		if !cardNodePath.visible:
			pointsTimer.start(originalTimeLeft)
			emit_signal("showCard")
			walkingTowardsStartingPoint = false
			highlightButton.disabled = false
			connect("clickOnCutsomer",levelGui.get_node("TutorialGui"),"click_on_cutsomer",[],CONNECT_ONESHOT)
			emit_signal("clickOnCutsomer")
			get_tree().paused = true

#checks order condition and applying the right gui + changes orderCompelted bool, then displaying gui.
signal handleBoxSprite

func check_order_condition(isOrderComplete):
	if isOrderComplete:
		orderCompleted = true
		answerSprite.texture = GameResources.GuiTexturesDict["checkMark"]
		connect("handleBoxSprite",get_node("/root/Game/Levels").get_child(0),"handle_box_sprite",[],CONNECT_ONESHOT)
		emit_signal("handleBoxSprite",true)
		Sounds.play_sound("confirmation","Sfx2")
		$AnimatedSprite/Box.show()
	else:
		answerSprite.texture = GameResources.GuiTexturesDict["cross"]
		connect("handleBoxSprite",get_node("/root/Game/Levels").get_child(0),"handle_box_sprite",[],CONNECT_ONESHOT)
		emit_signal("handleBoxSprite",false)
		Sounds.play_sound("error","Sfx2")
	display_gui()

#displays gui
func display_gui():
	guiTween.interpolate_property(answerSprite,"scale",Vector2(0,0),Vector2(1,1),0.5,Tween.TRANS_CUBIC,Tween.EASE_IN)
	guiTween.start()

#displays gui, or activates walk_out_of_bounds()
func _on_GuiTween_tween_completed(object, key):

	emit_signal("handleOrdersMenuButton",false)
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
	if pointsTimer.time_left < originalTimeLeft * pointsCalculationDict["bad"]:
		points = CORRECT_ORDER_POINTS * pointsCalculationDict["bad"]
	elif pointsTimer.time_left <= originalTimeLeft * pointsCalculationDict["nice"]:
		points = CORRECT_ORDER_POINTS * pointsCalculationDict["nice"]
	elif pointsTimer.time_left <= originalTimeLeft * pointsCalculationDict["good"] :
		points = CORRECT_ORDER_POINTS * pointsCalculationDict["good"]
	elif pointsTimer.time_left >= originalTimeLeft:
		points = CORRECT_ORDER_POINTS * pointsCalculationDict["perfect"]
	
	emit_signal("addPoints",points)
	



