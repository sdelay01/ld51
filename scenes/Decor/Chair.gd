extends Node2D
var isFree = true
var customer
var eugenePresent = null
func setFree(_isFree): isFree = _isFree
func setCustomer(_customer):
	customer = _customer
	if eugenePresent != null:
		eugenePresent.currentCustomer = customer
	if _customer != null and eugenePresent != null:
		customer.displayLetter()
