extends Node2D

signal timeout
var seconds = 0
var elapsed = 0.0
var blocked = false

var points = [Vector2(0, 0),Vector2(0, -10)]

func _ready():
	pass # Replace with function body.

func _process(delta):
	if blocked: return
	elapsed += delta
	$Label.text = str(int(seconds))
	if elapsed >= 0.15:
		var time = seconds + elapsed
		points[1] =  Vector2(sin(time * 36 * PI / 180), -cos(time * 36 * PI / 180)) * 10
		$Line2D.points = points
	if elapsed >= 1:
		seconds += 1
		elapsed = 0.0
		if seconds >= 10:
			emit_signal("timeout")
			seconds = 0.0
