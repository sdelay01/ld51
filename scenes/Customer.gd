extends Node2D

signal cut_done(positionX, customer)
signal play_note(number)
export (int) var speed = 80

var Key = preload("res://scenes/Key.tscn")
var key

var action = "walks_in"
var actions_needed = 5
var actions_done = 0
var actions = ""

const alphabet = "AZERTYUIOPMLKJHGFDSQWXCVBN"
var salon
var toward
var lineY = 140
var towardAction
var nextAction
var waiting = 0
var isReady = false
var blocked = false

var hairIndex
var headIndex
var availableIndex = null

func _ready():
	position = Vector2(400, lineY)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	hairIndex = rng.randi_range(1, 5)
	$HairFront.play(str(hairIndex))
	$HairBack.play(str(hairIndex))
	$HairBack.hide()
	rng.randomize()
	headIndex = rng.randi_range(1, 5)
	$Head.play(str(headIndex))
	rng.randomize()
	$BodyBottom.play(str(rng.randi_range(1, 5)))
	rng.randomize()
	$BodyTop.play(str(rng.randi_range(1, 5)))

func init(_salon, _actions_needed):
	salon = _salon
	actions_needed = _actions_needed
	setString()
	find_target()
	isReady = true

func setString():
	var string = ""
	var rng = RandomNumberGenerator.new()
	for _i in range(actions_needed):
		rng.randomize()
		var strIndex = rng.randi_range(0, 578) % 25
		string += alphabet[strIndex]
	actions = string
	
func find_target():
	var res = salon.whats_my_target(self)
	if res:
		toward = res[0]
		action = "walks_in"
		nextAction = res[1]
		availableIndex = res[2]
		return
		
	if action == "walks_in":
		action = "angry"

func set_target(_toward, _action, _nextAction):
	toward = _toward
	action = _action
	nextAction = _nextAction

func pressLetter(letter):
	if letter == actions[actions_done]:
		emit_signal("play_note", actions_done)
		hideLetter()
		actions_done += 1
		if actions_done == actions_needed:
			emit_signal("cut_done", position.x, self)
			action = "walks_out"
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
	if blocked: return
	$Label.text = action
	if action == "chair":
		$Head.hide()
		$HairFront.hide()
		$HairBack.show()
		$BodyBottom.hide()
		$BodyTop.hide()
	else:
		$Head.show()
		$HairFront.show()
		$HairBack.hide()
		$BodyBottom.show()
		$BodyTop.show()

	if action == "walks_out":
		$HairFront.hide()
	
	if action == "angry": $Head.play(str(headIndex) + "_angry")
	else: $Head.play(str(headIndex))
	
	if action == "walks_in":
		position.y = lineY
		position.x -= delta * speed
		if position.x - toward.position.x < 2:
			action = nextAction
			toward.setCustomer(self)
			position.y = toward.position.y
		
	if action == "seat":
		waiting += delta
		if waiting > 0.3:
			find_target()
			waiting = 0
		
	if action == "walks_out":
		position.y = lineY
		position.x += delta * speed
		if position.x > 500: queue_free()
		
	if action == "angry":
		waiting += delta
		if waiting > 0.3:
			find_target()
			waiting = 0
