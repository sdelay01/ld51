extends Node2D

signal input_event(viewport, event, shape_idx)

var prices = {
	1: 50,
	2: 75,
	3: 100,
}
var price

func init(level):
	var plural = ""
	if level > 1: plural = "s"
	price = prices[level]
	$Node2D/Help.text = "-" + str(level) + "  letter" + plural
	$Price.text = "$" + str(price)

func _on_Area2D_input_event(viewport, event, shape_idx):
	emit_signal("input_event", viewport, event, shape_idx)
