extends Node2D

signal timeout
var seconds = 0.0

func _ready():
	pass # Replace with function body.

func _process(delta):
	seconds += delta
	$Label.text = str(int(seconds))
	if seconds >= 10:
		emit_signal("timeout")
		seconds = 0.0
