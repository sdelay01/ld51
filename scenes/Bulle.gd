extends Node2D

signal text_done
var texts = []

func _ready():
	$Sprite.hide()
	$Label.hide()
	$Area2D.hide()

func displayText(_texts):
	texts = _texts
	$Sprite.show()
	$Label.show()
	$Area2D.show()
	nextSentence()

func nextSentence():
	var text = texts.pop_front()
	$Label.percent_visible = 0
	$Label.text = text

func _process(delta):
	$Label.percent_visible += delta

func _on_Area2D_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if texts.size() == 0:
			$Sprite.hide()
			$Label.hide()
			$Area2D.hide()
			emit_signal("text_done")
		else:
			nextSentence()
