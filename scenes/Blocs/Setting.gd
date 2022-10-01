extends Node2D

signal click
var status = "on"
var icon

func init(_icon):
	icon = _icon
	$Icon.play(icon + "_" + status)

func toggle():
	if status == "on": status = "off"
	else: status = "on"
	$Icon.play(icon + "_" + status)

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		toggle()
		emit_signal("click")

func _on_Area2D_mouse_entered():
	modulate = Color(1, 1, 1, 0.8)


func _on_Area2D_mouse_exited():
	modulate = Color(1, 1, 1, 1)
