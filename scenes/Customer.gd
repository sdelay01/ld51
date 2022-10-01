extends Node2D

signal need_letter(letter)
signal cut_done

export (int) var speed = 80

var action = "walks_in"
var actions_needed = 5
var actions_done = 0
var actions = ""

var salon
var towardX
var towardY
var lineY = 160
var towardAction
var nextAction
var waiting = 0
var persona = 1
var isReady = false

func _ready():
	position = Vector2(400, lineY)
	actions = "ickqm"
	persona = 1

func init(_salon):
	salon = _salon
	find_target()
	isReady = true

func find_target():
	var nextChair = salon.get_next_chair()
	if nextChair:
		set_target(nextChair.position.x, nextChair.position.y, "walks_in", "chair")
		return
	var nextSeat = salon.get_next_seat()
	if nextSeat:
		set_target(nextSeat.position.x, nextSeat.position.y, "walks_in", "seat")
		return
	
	if action == "seat":
		action = "wait"

	if action == "walks_in":
		action = "angry"

func set_target(_towardX, _towardY, _towardAction, _nextAction):
	towardX = _towardX
	towardY = _towardY
	towardAction = _towardAction
	nextAction = _nextAction

func one_more_letter():
	emit_signal("need_letter", actions[actions_done])

func letter_done():
	actions_done += 1
	if actions_done == actions_needed:
		emit_signal("cut_done")
		
func _process(delta):
	if !isReady: return
	$Label.text = action
	$Sprite.play(str(persona) + "-" + action)
	if action == "walks_in":
		position.y = lineY
		position.x -= delta * speed
		if position.x - towardX < 5:
			action = nextAction
			position.y = towardY
		
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
