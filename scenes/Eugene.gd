extends KinematicBody2D

var velocity = Vector2.ZERO
export (int) var speed = 320

func _ready():
	pass

func get_input():
	velocity.x = 0

	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	

func _physics_process(delta):
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)

	if velocity.x != 0:
		$Sprite.play("default")
		$Sprite.flip_h = velocity.x < 0
	else:
		$Sprite.play("default")
