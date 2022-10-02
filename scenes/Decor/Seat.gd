extends Node2D
var customer = null
func _ready():
	setCustomer(null)
func setCustomer(_customer):
	customer = _customer
