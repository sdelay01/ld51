extends Node2D

func setAmount(amount):
	$Node2D/Label.text = "$" + str(amount)
