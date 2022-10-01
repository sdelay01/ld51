extends Node2D

signal cut_done(positionX, customer)
export (int) var speed = 300 #80

var Key = preload("res://scenes/Key.tscn")
var key

var action = "walks_in"
var actions_needed = 5
var actions_done = 0
var actions = ""

const alphabet = "AZERTYUIOPMLKJHGFDSQWXCVBN"
var salon
var toward
var lineY = 160
var towardAction
var nextAction
var waiting = 0
var persona = 1
var isReady = false

func _ready():
	position = Vector2(400, lineY)
	persona = 1
	setString()

func init(_salon, _actions_needed):
	salon = _salon
	actions_needed = _actions_needed
	find_target()
	isReady = true

func setString():
	var string = ""
	for _i in range(5):
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var strIndex = rng.randi_range(0, 25)
		string += alphabet[strIndex]
	actions = string
	actions = "AZERT" # todo REMOVE THIS
	
func find_target():
	var nextChair = salon.get_next_chair()
	if nextChair:
		if toward:
			toward.setFree(true)
			toward.setCustomer(null)
		set_target(nextChair, "walks_in", "chair")
		return
	var nextSeat = salon.get_next_seat()
	if nextSeat:
		set_target(nextSeat, "walks_in", "seat")
		return

	if action == "walks_in":
		action = "angry"

func set_target(_toward, _action, _nextAction):
	toward = _toward
	action = _action
	nextAction = _nextAction

func pressLetter(letter):
	if letter == actions[actions_done]:
		hideLetter()
		actions_done += 1
		if actions_done == actions_needed:
			emit_signal("cut_done", position.x, self)
			action = "walks_out"
			toward.setFree(true)
			toward.setCustomer(null)
			return
		displayLetter()

func displayLetter():
	key = Key.instance()
	key.scale = Vector2(0.5, 0.5)
	key.position = Vector2(31, -12)
	add_child(key)
	key.appear(actions[actions_done])

func hideLetter():
	if key: key.diseapper()

func _process(delta):
	if !isReady: return
	$Label.text = action
	$Sprite.play(str(persona) + "-" + action)
	if action == "walks_in":
		position.y = lineY
		position.x -= delta * speed
		if position.x - toward.position.x < 5:
			action = nextAction
			toward.setFree(false)
			toward.setCustomer(self)
			position.y = toward.position.y
		
	if action == "seat":
		waiting += delta
		if waiting > 1:
			find_target()
			waiting = 0
		
	if action == "walks_out":
		position.y = lineY
		position.x += delta * speed
		if position.x > 500: queue_free()
		
	if action == "angry":
		waiting += delta
		if waiting > 1:
			find_target()
			waiting = 0
