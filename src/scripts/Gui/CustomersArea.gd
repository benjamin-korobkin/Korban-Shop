extends Control





onready var highlightedCustomer 




func handle_highlights(customerPath):
	highlightedCustomer = customerPath
	for customer in get_children():
		if customer != customerPath:
			customer.remove_highlight()


func disable_customer_buttons():
	for customer in get_children():
			customer.highlightButton.disabled = true

func enable_customer_buttons():
	for customer in get_children():
			customer.highlightButton.disabled = false
