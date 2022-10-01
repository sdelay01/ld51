extends Node2D

func _ready():
	modulate = Color(1, 1, 1, 0)

func appear(letter):
	$Node2D/Label.text = letter
	var tween = get_node("Tween")
	tween.interpolate_property(self, "modulate",
		Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "position",
		Vector2(position)+Vector2(0,5), Vector2(position), 0.2,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func diseapper():
	queue_free()
