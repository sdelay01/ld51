extends Node2D

func _ready():
	pass # Replace with function body.

func appear(letter):
	$Node2D/Label.text = letter

func diseapper():
	queue_free()
