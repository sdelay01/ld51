extends Node2D

signal timeout
var seconds = 0.0
var blocked = false

func _ready():
	pass # Replace with function body.

func _process(delta):
	if blocked: return
	seconds += delta
	$Label.text = str(int(seconds))
	if seconds >= 4:
		emit_signal("timeout")
		seconds = 0.0
