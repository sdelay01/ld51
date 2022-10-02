extends Node2D
var customer
var eugenePresent = null
func setCustomer(_customer):
	customer = _customer
	if eugenePresent != null:
		eugenePresent.currentCustomer = customer
	if _customer != null and eugenePresent != null:
		customer.displayLetter()
