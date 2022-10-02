extends Node2D
var isFree = true
var customer
var eugenePresent = null
func setFree(_isFree):
	isFree = _isFree
	$Free.text = str(isFree)
func setCustomer(_customer):
	customer = _customer
	$Customer.text = str(customer)
	if eugenePresent != null:
		eugenePresent.currentCustomer = customer
	if _customer != null and eugenePresent != null:
		customer.displayLetter()
