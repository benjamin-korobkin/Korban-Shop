extends Control



onready var openPositions : Dictionary = {
	"Pos1" : {
		"position" : $"../CardsMenuPositions/Pos1".position,
		"open" : true,
	},
	"Pos2" : {
		"position" : $"../CardsMenuPositions/Pos2".position,
		"open" : true,
	},
	"Pos3" : {
		"position" : $"../CardsMenuPositions/Pos3".position,
		"open" : true,
	},
	"Pos4" : {
		"position" : $"../CardsMenuPositions/Pos4".position,
		"open" : true,
	},
}

onready var highlightedCard


# gets params from customer node, spawns a card with the right text and order dictionary, then adds it as a child
func spawn_card(category,occasion,KorbanotDict,customerPath):
	yield(get_tree(),"idle_frame")
	var cardRsc = GameResources.scenesDict["card"].instance()
	cardRsc.position = get_parent().get_node("CardsMenuPositions").get_child(0).position
## checks if the category is one Bechor or Maaser or Pesach, and ignores the occasion text if true
## else adds category and occasion as text
	if category == "Bechor" or category == "Maaser" or category == "Pesach":
		cardRsc.occasionText = category
	else:
		cardRsc.occasionText = category + "\n" + occasion
	cardRsc.customerNodePath = customerPath
	cardRsc.KorbanotDict = KorbanotDict.duplicate(true)
	var positionsArray : Array = get_card_position()
	cardRsc.position = positionsArray[0]
	cardRsc.positionName = positionsArray[1]
	cardRsc.visible = false
	add_child(cardRsc)

func get_card_position():
	for pos in openPositions:
		if openPositions[pos]["open"] == true:
			openPositions[pos]["open"] = false
			var cardPosition = openPositions[pos]["position"]
			var positionName = pos
			var positionsArray : Array
			positionsArray.append(cardPosition)
			positionsArray.append(positionName)
			return positionsArray
			break # what's the purpose of break?


func handle_highlights(cardPath):
	highlightedCard = cardPath
	for card in get_children():
		if card != cardPath:
			card.remove_highlight()


#compares current order with the highlighted card animals dictionary, if they're the same, emits signal to
#complete order, else, emits a signal to player to walk to order counter.
func compare_order_with_card(order):
	if highlightedCard == null:
		return
	if order.has_all(highlightedCard.KorbanotDict.keys()):
		var highlightedcardOrderArray = highlightedCard.KorbanotDict.keys()
		var orderArray = order.keys()
		highlightedcardOrderArray.sort()
		orderArray.sort()
		for korbanOrder in highlightedcardOrderArray:
			if highlightedCard.KorbanotDict[korbanOrder] == order[korbanOrder]:
				pass
			else:
				#wrong order, activates a function is highlighted card to activate X ui on customer, and make player
				#move back to the orders table to "bring back to order", punishing the player
				#for a wrong answer
				highlightedCard.activate_customer_ui(false)
				return
#if order is completed, activates function in highlighted card to queue_free
#and make highlighted customer move out of bounds and queue free aswell.
		highlightedCard.activate_customer_ui(true)
	else:
		highlightedCard.activate_customer_ui(false)



# gets params from customer node, spawns a card with the right text and order dictionary, then adds it as a child
func spawn_tutorial_card(category,occasion,KorbanotDict,customerPath):
	yield(get_tree(),"idle_frame")
	var cardRsc = GameResources.scenesDict["tutorialCard"].instance()
	cardRsc.position = get_parent().get_node("CardsMenuPositions").get_child(0).position
## checks if the category is one Bechor or Maaser or Pesach, and ignores the occasion text if true
## else adds category and occasion as text
	if category == "Bechor" or category == "Maaser" or category == "Pesach":
		cardRsc.occasionText = category
	else:
		cardRsc.occasionText = category + "\n" + occasion
	cardRsc.customerNodePath = customerPath
	cardRsc.KorbanotDict = KorbanotDict.duplicate(true)
	var positionsArray : Array = get_card_position()
	cardRsc.position = positionsArray[0]
	cardRsc.positionName = positionsArray[1]
	cardRsc.visible = false
	add_child(cardRsc)


