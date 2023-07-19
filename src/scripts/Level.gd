extends Control


onready var player = $PlayerArea/Player
onready var playerTween = $PlayerArea/Player/Tween
onready var orderCounterPos = $PlayerArea/OrderCounterPos
onready var shopCounterPos = $PlayerArea/ShopCounterPos
onready var customersArea = $CustomersArea
onready var customerSpawner = $CustomerSpawner
onready var levelGui = get_node("/root/Game/GuiSafeArea/LevelGui")

# For now, use an Array containing the occasions
var currentOrders : Array

signal handleOrdersMenuButton
signal setOrder(order)
signal setPosition()
signal compareOrder
signal setPointsAndTime
signal handleShopButtons

#player rotation degress
onready var playerRotations : Dictionary = {
	"up" : 0.0,
	"down" : 180.0
}

#positions that customer nodes iterate through and see if their open.
onready var openPositions : Dictionary = {
	"Pos1" : {
		"position" : $CustomersPositionsArea/Pos1.position,
		"open" : true,
	},
	"Pos2" : {
		"position" : $CustomersPositionsArea/Pos2.position,
		"open" : true,
	},
	"Pos3" : {
		"position" : $CustomersPositionsArea/Pos3.position,
		"open" : true,
	},
	"Pos4" : {
		"position" : $CustomersPositionsArea/Pos4.position,
		"open" : true,
	},
}
onready var outOfBoundsPositions : Dictionary = {
	"right" : $CustomersPositionsArea/outOfBoundsPosRight.position,
	"left" : $CustomersPositionsArea/outOfBoundsPosLeft.position,
}
onready var customerOrderPos = $CustomersPositionsArea/CustomerOrderPos.position



onready var randNumGenerator = RandomNumberGenerator.new()

onready var pointsTimerMenuNode = get_node("/root/Game/GuiSafeArea/LevelGui/PointsTimerMenu")


func _ready():
	connect("handleShopButtons",levelGui,"handle_shop_buttons",[],CONNECT_ONESHOT)
	emit_signal("handleShopButtons",name)
	randomize()
	spawn_customer()
	randNumGenerator.randomize()
	set_safe_area()
	yield(get_tree(),"idle_frame")
	connect("compareOrder",get_node("/root/Game/GuiSafeArea/LevelGui/CardsMenu"),"compare_order_with_card")
	connect("handleOrdersMenuButton",levelGui,"handle_orders_menu_button")
	connect("setPointsAndTime",pointsTimerMenuNode,"set_timer_and_points")
	emit_signal("setPointsAndTime",GameResources.levelsTimeDict[name],GameResources.levelsPointTreshold[name])
func set_safe_area():
	var safeArea = OS.get_window_safe_area()
	var screenSize = get_viewport().get_visible_rect().size
	var leftMargin = safeArea.position / (screenSize - safeArea.position)
	set_anchor(MARGIN_LEFT,leftMargin.x)
	set_anchor(MARGIN_TOP,leftMargin.y)


#creates customer instance.
#sets the customers order, position to walk to,gender, and adds it as child of customers area.
func spawn_customer():
	yield(get_tree(),"idle_frame")
	var customerRsc = GameResources.scenesDict["customer"].instance()
	customerRsc.position = rect_position
	connect("setOrder",customerRsc,"get_order")
	connect("setPosition",customerRsc,"set_pos")
	emit_signal("setPosition",get_customer_position())
	emit_signal("setOrder",get_customer_order())
	disconnect("setOrder",customerRsc,"get_order")
	disconnect("setPosition",customerRsc,"set_pos")
	customersArea.add_child(customerRsc,true)

#returns random order, full orderArray goes to customer, and from the customer's node creating a card.
func get_customer_order():
	randNumGenerator.randomize()
	var currentLevelsToTakeFrom : Array
	# TODO: I understand the logic here but I'm not a fan of this loop using break.
	# Need to find a smarter way to implement what we want.
	for level in GameResources.korbansDict.size():
		## name == Node.name (e.g. Tutorial, Level 1, ...)
		if name == GameResources.korbansDict.keys()[level]:
			currentLevelsToTakeFrom.append(GameResources.korbansDict.keys()[level])
			break
		else:
			currentLevelsToTakeFrom.append(GameResources.korbansDict.keys()[level])
	var uniqueChosen = false
	# TODO: get rid of all gender references.
	var chosenLevel = currentLevelsToTakeFrom[randNumGenerator.randi_range(0,currentLevelsToTakeFrom.size() - 1)]
	var customerGender = get_customer_gender(chosenLevel)
	var randomOrder = randNumGenerator.randi_range(0,GameResources.korbansDict[chosenLevel][customerGender].keys().size() -1)
	var fullOrder = GameResources.korbansDict[chosenLevel][customerGender].keys()[randomOrder]
	var orderDict = GameResources.korbansDict[chosenLevel][customerGender][fullOrder].duplicate(true)
	var category  = GameResources.korbansDict[chosenLevel][customerGender].keys()[randomOrder]
	var occasion  = orderDict.keys()[0]
	var KorbanotDict = orderDict[occasion]["animals"]
	var orderArray : Array
	orderArray.append(category)
	orderArray.append(occasion)
	orderArray.append(KorbanotDict)
	orderArray.append(customerGender)
	return orderArray

#returns the customers gender based on the level.
func get_customer_gender(levelName):
	var customerGender
	match GameResources.levelsGenderDict[levelName]:
		"male":
			customerGender = "male"
		"female":
			customerGender = "female"
		"male and female":
			var randTexture = randNumGenerator.randi_range(0,1)
			if randTexture == 0:
				customerGender = "male"
			else:
				customerGender = "female"
	return customerGender

#gets customer position, returns as array with name and position.
func get_customer_position():
	for pos in openPositions:
		if openPositions[pos]["open"] == true:
			openPositions[pos]["open"] = false
			var customerPosition = openPositions[pos]["position"]
			var positionName = pos
			var positionsArray : Array
			positionsArray.append(customerPosition)
			positionsArray.append(positionName)
			return positionsArray
			#break

onready var order 
#moves the player sprite to the order counter
func move_player_to_order_counter(_order):
	customersArea.disable_customer_buttons()
	player.rotation_degrees = playerRotations["up"]
	playerTween.interpolate_property(player,"position",player.position,orderCounterPos.position,2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	playerTween.start()
	player.position = orderCounterPos.position
	order = _order
	emit_signal("handleOrdersMenuButton",false)
	

#moves the player sprite to the shop counter, then signals to compare customer and order
func move_player_to_shop_counter():
	player.get_node("Box").show()
	player.rotation_degrees = playerRotations["down"]
	playerTween.interpolate_property(player,"position",player.position,shopCounterPos.position,2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	playerTween.start()
	player.position = orderCounterPos.position


#depending on play position, either goes to order counter or shop counter to compare order.
func _on_Tween_tween_completed(object, key):
	if player.position == orderCounterPos.position:
		player.get_node("Box").hide()
		get_node("CountersControl/KorbanBox").show()
		yield(get_tree().create_timer(1),"timeout")
		move_player_to_shop_counter()
		get_node("CountersControl/KorbanBox").hide()
	elif player.position == shopCounterPos.position:
		yield(get_tree().create_timer(0.5),"timeout")
		var currentOrder = order.duplicate(true)
		order.clear()
		emit_signal("compareOrder",currentOrder)
		customersArea.enable_customer_buttons()

func handle_box_sprite(hide):
	if hide:
		player.get_node("Box").hide()
	else:
		player.get_node("Box").show()

#checks if customers reached 4 which is max allowed, then one shots customerspawner.
func check_for_customers():
	if customersArea.get_child_count() == 4:
		customerSpawner.one_shot = true
		return
	else:
		spawn_customer()

#calls check_for_customers()
func _on_CustomerSpawner_timeout():
	var randomTime = randNumGenerator.randi_range(1,3)
	customerSpawner.wait_time = randomTime
	check_for_customers()
