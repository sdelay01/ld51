extends KinematicBody2D

var velocity = Vector2.ZERO
export (int) var speed = 320
var blocked = false
var currentCustomer

func _ready():
	pass

func get_input():
	velocity.x = 0

	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
	

func _physics_process(_delta):
	if blocked: return
	get_input()
	velocity = move_and_slide(velocity, Vector2.UP)
	if position.x < 50: position.x = 50
	if position.x > 400 : position.x = 400

	if velocity.x != 0:
		$Sprite.play("default")
		$Sprite.flip_h = velocity.x < 0
	else:
		$Sprite.play("default")

func _input(event):
	if blocked: return
	if event is InputEventKey and event.is_pressed() and \
		event.get_scancode() >= 65 and event.get_scancode() <= 90 and \
		currentCustomer:
			currentCustomer.pressLetter(toLetter[str(event.get_scancode())])
		
func _on_area_entered(area):
	var workingChair = area.get_parent()
	workingChair.eugenePresent = self
	if workingChair.customer:
		currentCustomer = workingChair.customer
		workingChair.customer.displayLetter()

func _on_area_exited(area):
	var workingChair = area.get_parent()
	workingChair.eugenePresent = null
	if workingChair.customer:
		currentCustomer = null
		workingChair.customer.hideLetter()

var toLetter = {
	"65" : "A",
	"66" : "B",
	"67" : "C",
	"68" : "D",
	"69" : "E",
	"70" : "F",
	"71" : "G",
	"72" : "H",
	"73" : "I",
	"74" : "J",
	"75" : "K",
	"76" : "L",
	"77" : "M",
	"78" : "N",
	"79" : "O",
	"80" : "P",
	"81" : "Q",
	"82" : "R",
	"83" : "S",
	"84" : "T",
	"85" : "U",
	"86" : "V",
	"87" : "W",
	"88" : "X",
	"89" : "Y",
	"90" : "Z",
}
