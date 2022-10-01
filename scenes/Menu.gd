extends Node2D

signal start
var Overlay = preload("res://scenes/Overlay.tscn")
var overlay
var Title = preload("res://scenes/Title.tscn")
var cannotClick = false

func _ready():
	pass

func _on_start_input_event(_viewport, event, _shape_idx):
	if cannotClick: return
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		cannotClick = true
		overlay = Overlay.instance()
		add_child(overlay)
		var tween = Tween.new()
		add_child(tween)
		tween.interpolate_property(overlay, "modulate",
			Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.connect("tween_all_completed", self, "ready_to_start")
		tween.start()

func ready_to_start():
	emit_signal("start")

func _on_start_mouse_entered(): $Sprite.modulate = Color(1, 1, 1, 0.8)
func _on_start_mouse_exited(): $Sprite.modulate = Color(1, 1, 1, 1)
