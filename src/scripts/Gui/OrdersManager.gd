extends VBoxContainer


onready var ordersMenu = get_parent()

onready var orderAmountDict = {
	"Kid" : 0,
	"Lamb" : 0,
	"Ram" : 0,
	"Bull" : 0,
#	"Sheep" : 0,
#	"Goat" : 0,
#	"Cattle" : 0,
}

#connected trough scene tree already.
signal completeOrder
signal resetAll


#changes amount on dictionary, called from children.
func change_amount(korban,amount):
	orderAmountDict[korban] += amount

#resets dictionary and children labels.
func reset():
	for korban in orderAmountDict.keys():
		orderAmountDict[korban] = 0 
	emit_signal("resetAll")

#sends dictionary to parent, then resets everything.
func _on_CompleteOrderButton_pressed():
	var orderDict : Dictionary
	for korban in orderAmountDict.keys():
		if orderAmountDict[korban] != 0:
			orderDict[korban] = orderAmountDict[korban]
	emit_signal("completeOrder",orderDict)
	reset()
