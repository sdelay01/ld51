extends Node2D
var isFree = true
var customer = null
func _ready():
	setFree(true)
	setCustomer(null)
func setFree(_isFree):
	isFree = _isFree
	$Free.text = str(isFree)
func setCustomer(_customer):
	customer = _customer
	$Customer.text = str(_customer)
