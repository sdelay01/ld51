extends Node2D

signal toggle_music
var Background = preload("res://scenes/Decor/Background.tscn")
var Chair = preload("res://scenes/Decor/Chair.tscn")
var Mirror = preload("res://scenes/Decor/Mirror.tscn")
var Seat = preload("res://scenes/Decor/Seat.tscn")
var Haircut25 = preload("res://scenes/Decor/Haircut25.tscn")
var Title = preload("res://scenes/Title.tscn")
var Overlay = preload("res://scenes/Overlay.tscn")
var overlay
var Money = preload("res://scenes/Blocs/Money.tscn")
var money
var moneyAmount = 100

var CustomLabel = preload("res://scenes/Label.tscn")

#var Buy = preload("res://scenes/Blocs/Buy.tscn")
#var buy
var Setting = preload("res://scenes/Blocs/Setting.tscn")
var buyOpen = false

var Customer = preload("res://scenes/Customer.tscn")
var customers = []
var customersNode
var Counter = preload("res://scenes/Counter.tscn")
var counter
var Eugene = preload("res://scenes/Eugene.tscn")
var eugene

var Bulle = preload("res://scenes/Bulle.tscn")
var bulle

var furnitureNode2D # Node2D for all seats and chairs and mirrors
var chairs = []
var seats = []
var tempObjects = []

var objectives = [
	"first_haircut",
	"earn_150",
	"buy_chair",
	"buy_seat",
	"buy_cissors_lvl_1",
	"buy_pole",
	"earn_1500"
]
var objective = objectives[0]

func _ready():
	var bg = Background.instance()
	add_child(bg)
	var h25 = Haircut25.instance()
	h25.position = Vector2(290, 50)
	add_child(h25)
	
	var title = Title.instance()
	title.position = Vector2(200, 30)
	add_child(title)

	furnitureNode2D = Node2D.new()
	add_child(furnitureNode2D)

	chairs.push_back(add_chair(1, false, furnitureNode2D))
	add_mirror(1, furnitureNode2D)
	#add_chair(2) # TODO when buying
	seats.push_back(add_seat(1, false, furnitureNode2D))
	#add_seat(2) # TODO when buying
	
	eugene = Eugene.instance()
	add_child(eugene)
	eugene.position = Vector2(100, 210)
	eugene.scale = Vector2(2, 2)
	
	money = Money.instance()
	money.setAmount(moneyAmount)
	#add_child(money)

	customersNode = Node2D.new()
	add_child(customersNode)
	
	bulle = Bulle.instance()
	bulle.position = Vector2(256, 280)
	add_child(bulle)

	#open_overlay()
	
	#on_ready_to_start()
	tuto_completed()
	
func prepareButtons():
	var t = ["pause", "sound", "music", "buy"]
	var index = 0
	for butt in t:
		var button = Setting.instance()
		button.position.y = 5 + 40 * index
		button.init(butt)
		button.connect("click", self, "trigger_" + butt)
		add_child(button)
		index += 1
	
func trigger_pause():
	if counter and counter.blocked: unpause()
	else: pause()

func trigger_sound():
	pass

func trigger_music():
	emit_signal("toggle_music")

func trigger_buy():
	if buyOpen:
		overlay.queue_free()
		for temp in tempObjects:
			temp.queue_free()
		tempObjects = []
	else:
		overlay = Overlay.instance()
		overlay.modulate.a = 0.8
		add_child(overlay)
		if chairs.size() == 1:
			tempObjects.push_back(add_mirror(2, overlay))
			tempObjects.push_back(add_chair(2, true, overlay))
		if seats.size() == 1:
			tempObjects.push_back(add_seat(2, true, overlay))
	buyOpen = !buyOpen
	
func open_overlay():
	overlay = Overlay.instance()
	add_child(overlay)
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(overlay, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "on_ready_to_start")
	tween.start()
	
func on_ready_to_start():
	if overlay: overlay.queue_free()
	overlay = null
	bulle.displayText([
		"Welcome to the haidressing salon     (click to continue)",
		"Use left and right arrows to move",
		"A customer is entering every 10 seconds.",
		"Let them sit face to the mirror",
		"Then press the displayed keys to make the haircut,",
		"Don't make your customers wait !",
		"Good luck !                           "
	])
	bulle.connect("text_done", self, "tuto_completed")

func tuto_completed():
	#bulle.disconnect("text_done", self, "tuto_completed")
	counter = Counter.instance()
	counter.connect("timeout", self, "on_counter_timeout")
	counter.position = Vector2(400, 200)
	add_child(counter)
	add_customer()
	prepareButtons()

func on_counter_timeout():
	add_customer()

func add_customer():
	if customers.size() >= 4: return
	var c = Customer.instance()
	c.connect("cut_done", self, "on_cut_done")
	customers.push_back(c)
	customersNode.add_child(c)
	c.init(self, 5)
	
func on_cut_done(_posX, _customer):
	if objective == "first_haircut":
		pause()
		bulle.displayText([
			"You've made your first haircut, Good !",
			"Your next objective is to earn 150$"
		])
		bulle.connect("text_done", self, "obj_first_haircut")

	customers.erase(_customer)
	moneyAmount += 25
	money.setAmount(moneyAmount)

	var n2 = Node2D.new()
	var l = CustomLabel.instance()
	l.modulate = Color( 0.894118, 0.819608, 0.196078, 1 )
	n2.add_child(l)
	add_child(n2)
	l.text = "+ $25"
	n2.scale = Vector2(2, 2)
	var tween = Tween.new()
	tween.interpolate_property(n2, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5,
		Tween.TRANS_QUART, Tween.EASE_IN)
	tween.interpolate_property(n2, "position",
		Vector2(_posX, 10), Vector2(_posX, -20), 1.5,
		Tween.TRANS_QUART, Tween.EASE_IN)
	add_child(tween)
	tween.start()

	if objective == "earn_150" and moneyAmount >= 150:
		pause()
		bulle.displayText([
			"You've earned $150, good!        ",
			"With that money, buy a new chair."
		])
		bulle.connect("text_done", self, "obj_earn_150")

func obj_first_haircut():
	unpause()
	objective = "earn_150"

func obj_earn_150():
	unpause()
	objective = "buy_chair"

func pause():
	eugene.blocked = true
	counter.blocked = true

func unpause():
	eugene.blocked = false
	counter.blocked = false

func get_next_chair():
	for c in chairs:
		if c.isFree: return c
	return false

func get_next_seat():
	for s in seats:
		if s.isFree: return s
	return false

func add_chair(_rank, _withPriceTag, _parent):
	var c = Chair.instance()
	_parent.add_child(c)
	c.position = Vector2(_rank * 120 - 100, 120)
	if _withPriceTag:
		var priceTag = add_price("$150", Vector2(0,0), "chair")
		c.add_child(priceTag)
	return c

func add_mirror(_rank, _parent):
	var m = Mirror.instance()
	_parent.add_child(m)
	m.position = Vector2(_rank * 120 - 100, 60)
	return m

func add_seat(_rank, _withPriceTag, _parent):
	var s = Seat.instance()
	s.position = Vector2(160 + _rank * 64, 100)
	_parent.add_child(s)
	if _withPriceTag:
		var priceTag = add_price("$100", Vector2(0,0), "seat")
		s.add_child(priceTag)
	return s

func add_price(_text, _pos, _type):
	var cl = CustomLabel.instance()
	var n2 = Node2D.new()
	n2.add_child(cl)
	cl.text = _text
	n2.position = _pos
	n2.add_child(add_buying_click(_type))
	return n2

func add_buying_click(_type):
	var a2 = Area2D.new()
	var c2 = CollisionShape2D.new()
	var sc2 = CapsuleShape2D.new()
	sc2.radius = 30
	sc2.height = 50
	c2.position = Vector2(64, 64)
	c2.shape = sc2
	a2.add_child(c2)
	a2.connect("input_event", self, "on_click_buy", [_type])
	return a2

func on_click_buy(_viewport, event, _shape_idx, _type):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if _type == "seat":
			trigger_buy()
			add_seat(2, false, furnitureNode2D)
		if _type == "chair":
			trigger_buy()
			add_mirror(2, furnitureNode2D)
			add_chair(2, false, furnitureNode2D)
			
