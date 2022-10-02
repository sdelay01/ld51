extends Node2D

signal toggle_music

var texture = load("res://assets/ld51.png")

var Background = preload("res://scenes/Decor/Background.tscn")
var Chair = preload("res://scenes/Decor/Chair.tscn")
var Mirror = preload("res://scenes/Decor/Mirror.tscn")
var Seat = preload("res://scenes/Decor/Seat.tscn")
var Overlay = preload("res://scenes/Overlay.tscn")
var overlay

var Clippers = preload("res://scenes/Blocs/Clippers.tscn")
var clippersLevel = 0

var Money = preload("res://scenes/Blocs/Money.tscn")
var money
var moneyAmount = 400

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
var furnitureSellNode2D
var nbChairs = 1
var nbSeats = 1

var availability = []
var objects = []
var mutex

var tempObjects = []

var finalObjective = 200
var objectives = [
	"first_haircut",
	"earn_150",
	"buy_thing",
	"earn_"+str(finalObjective)
]
var objective = "nop" #objectives[0] # TODO ne pas oublier ça

func _ready():
	mutex = Mutex.new()
	var bg = Background.instance()
	add_child(bg)

	furnitureNode2D = Node2D.new()
	add_child(furnitureNode2D)

	add_mirror(1, furnitureNode2D)
	add_mirror(2, furnitureNode2D)
	
	var chair1 = add_chair(1, false, furnitureNode2D)
	var seat1 = add_seat(1, false, furnitureNode2D)
	availability = [1, 1]
	objects = [chair1, seat1]
	
	eugene = Eugene.instance()
	add_child(eugene)
	eugene.position = Vector2(100, 210)
	eugene.scale = Vector2(2, 2)
	
	money = Money.instance()
	money.setAmount(moneyAmount)
	add_child(money)

	customersNode = Node2D.new()
	add_child(customersNode)
	
	bulle = Bulle.instance()
	bulle.position = Vector2(256, 280)
	add_child(bulle)

	overlay = Overlay.instance()
	add_child(overlay)
	overlay.hide()
	
	furnitureSellNode2D = Node2D.new()
	add_child(furnitureSellNode2D)
	
	#open_overlay()
	#on_ready_to_start()
	prepareBuyingArea()
	tuto_completed()
	
func whats_my_target(_customer):
	var index = 0
	mutex.lock()
	for available in availability:
		if _customer.availableIndex != null:
			if _customer.availableIndex < index: return
		if available == 1:
			var object = objects[index]
			var name = "chair"
			if object.name.find("Chair") == -1: name = "seat"
			availability[index] = 0
			if _customer.availableIndex != null: availability[_customer.availableIndex] = 1
			mutex.unlock()
			return [object, name, index]
		index += 1
	mutex.unlock()
	return false

func prepareButtons():
	var t = ["pause", "sound", "music"]
	var index = 0
	for butt in t:
		var button = Setting.instance()
		button.position.y = 5 + 40 * index
		button.init(butt)
		button.connect("click", self, "trigger_" + butt)
		add_child(button)
		index += 1

func prepareBuyingArea():
	var ba = Area2D.new()
	var cs = CollisionShape2D.new()
	var ci = CircleShape2D.new()
	ci.radius = 10
	cs.shape = ci
	ba.position = Vector2(40, 168)
	ba.add_child(cs)
	ba.connect("area_entered", self, "trigger_buy",  [true])
	ba.connect("area_exited", self, "trigger_buy", [false])
	add_child(ba)
	
func trigger_pause():
	if counter and counter.blocked:
		overlay.hide()
		unpause()
	else:
		overlay.show()
		overlay.modulate.a = 0.9
		pause()

func trigger_sound():
	pass

func trigger_music():
	emit_signal("toggle_music")

func trigger_buy(_area, newValue):
	buyOpen = newValue
	if buyOpen:
		pause()
		eugene.blocked = false
		overlay.show()
		overlay.modulate.a = 0.8
		if nbChairs == 1:
			tempObjects.push_back(add_mirror(2, furnitureSellNode2D))
			tempObjects.push_back(add_chair(2, true, furnitureSellNode2D))
		if nbSeats == 1:
			tempObjects.push_back(add_seat(2, true, furnitureSellNode2D))
		if clippersLevel < 3:
			tempObjects.push_back(add_clippers(clippersLevel + 1, furnitureSellNode2D))
	else:
		unpause()
		overlay.hide()
		for temp in tempObjects:
			call_deferred("removeBuyingObjects", temp)
		tempObjects = []

func removeBuyingObjects(_temp):
	_temp.queue_free()
func open_overlay():
	overlay.modulate.a = 1
	overlay.show()
	var tween = Tween.new()
	add_child(tween)
	tween.interpolate_property(overlay, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.connect("tween_all_completed", self, "on_ready_to_start")
	tween.start()
	
func on_ready_to_start():
	overlay.hide()
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
	bulle.disconnect("text_done", self, "tuto_completed")
	counter = Counter.instance()
	counter.connect("timeout", self, "on_counter_timeout")
	counter.position = Vector2(400, 200)
	add_child(counter)
	print("tuto completed")
	add_customer()
	prepareButtons()

func on_counter_timeout():
	add_customer()

func add_customer():
	for cu in customers:
		if cu.action == "angry":
			displayAmountBriefly("Salon full! - $20", Color(1, 1, 1, 1), Vector2(300, 300))
			moneyAmount -= 20
			money.setAmount(moneyAmount)
			return 
	var c = Customer.instance()
	c.connect("cut_done", self, "on_cut_done")
	customers.push_back(c)
	customersNode.add_child(c)
	if clippersLevel == 0:
		c.init(self, 5)
	else:
		c.init(self, 5 - (2 * clippersLevel - 1))

func on_cut_done(_posX, _customer):
	availability[_customer.availableIndex] = 1
	customers.erase(_customer)
	if objective == "first_haircut":
		pause()
		bulle.displayText([
			"You've made your first haircut, Good !",
			"Your next objective is to earn 150$"
		])
		bulle.connect("text_done", self, "obj_first_haircut")

	moneyAmount += 25
	money.setAmount(moneyAmount)

	displayAmountBriefly(" + $25", Color( 0.894118, 0.819608, 0.196078, 1 ), Vector2(_posX, 50))

	if objective == "earn_150" and moneyAmount >= 150:
		pause()
		bulle.displayText([
			"You've earned $150, good!        ",
			"With that money, buy something the improve the salon.",
			"To do so, get close to your vending machine,",
			"And click on what you want to buy.",
		])
		
		bulle.connect("text_done", self, "obj_earn_150")

	if moneyAmount >= finalObjective and objective == "earn_"+str(finalObjective):
		pause()
		bulle.displayText([
			"Brilliant! You can go your vacations!",
			"I can close this salon!",
			"Thank you for playing."
		])
		bulle.connect("text_done", self, "obj_buy_thing") # TODO
				
func obj_first_haircut():
	unpause()
	objective = "earn_150"

func obj_earn_150():
	unpause()
	prepareBuyingArea()
	objective = "buy_thing"

func pause():
	eugene.blocked = true
	counter.blocked = true
	for c in customers:
		c.blocked = true

func unpause():
	eugene.blocked = false
	counter.blocked = false
	for c in customers:
		c.blocked = false

func add_chair(_rank, _withPriceTag, _parent):
	var c = Chair.instance()
	_parent.add_child(c)
	c.position = Vector2(_rank * 110 - 36, 120)
	if _withPriceTag:
		var priceTag = add_price_tag(150, Vector2(0,0), "chair", Vector2(_rank * 120 - 100, 120))
		c.add_child(priceTag)
	return c

func add_mirror(_rank, _parent):
	var m = Mirror.instance()
	_parent.add_child(m)
	m.position = Vector2(_rank * 110 - 36, 60)
	return m

func add_seat(_rank, _withPriceTag, _parent):
	var s = Seat.instance()
	s.position = Vector2(224 + _rank * 64, 100)
	_parent.add_child(s)
	if _withPriceTag:
		var priceTag = add_price_tag(100, Vector2(0,0), "seat", Vector2(160 + _rank * 64, 100))
		s.add_child(priceTag)
	return s

func add_price_tag(_price, _pos, _type, _objectPos):
	var n2 = Node2D.new()

	# Price tag
	var sprite = Sprite.new()
	sprite.region_enabled = true
	sprite.texture = texture
	sprite.region_rect = Rect2(192, 192, 64, 64)
	sprite.position = Vector2(0, 0)
	sprite.centered = false
	n2.add_child(sprite)
	# Price
	var cl = CustomLabel.instance()
	cl.text = "$" + str(_price)
	n2.add_child(cl)
	
	# Click zone
	var a2 = Area2D.new()
	var c2 = CollisionShape2D.new()
	var sc2 = CapsuleShape2D.new()
	sc2.radius = 30
	sc2.height = 50
	c2.position = Vector2(64, 64)
	c2.shape = sc2
	a2.add_child(c2)
	a2.connect("input_event", self, "on_click_buy", [_type, _price, _objectPos])
	n2.add_child(a2)

	n2.position = _pos
	return n2

func add_clippers(_level, _parent):
	var clippers = Clippers.instance()
	clippers.position = Vector2(330, 230)
	clippers.init(_level)
	_parent.add_child(clippers)
	clippers.connect("input_event", self, "on_click_buy", ["clippers", clippers.price, clippers.position])
	return clippers

func on_click_buy(_viewport, event, _shape_idx, _type, _price, _objectPos):
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		if moneyAmount >= _price:
			displayAmountBriefly("- $" + str(_price), Color(1, 1, 1, 1), _objectPos)
			moneyAmount -= _price
			money.setAmount(moneyAmount)
			trigger_buy(null, false)
			if _type == "seat":
				var s = add_seat(2, false, furnitureNode2D)
				nbSeats += 1
				mutex.lock()
				objects.push_back(s)
				availability.push_back(1)
				mutex.unlock()
			if _type == "chair":
				add_mirror(2, furnitureNode2D)
				var c = add_chair(2, false, furnitureNode2D)
				nbChairs += 1
				mutex.lock()
				objects.insert(1, c)
				availability.insert(1, 1)
				for cu in customers:
					if cu.availableIndex != null and cu.availableIndex >= 1:
						cu.availableIndex += 1
				mutex.unlock()
			if _type == "clippers":
				clippersLevel += 1
			if objective == "buy_thing":
				pause()
				bulle.displayText([
					"Brilliant! Now you know everything to run the salon.",
					"Let's earn $"+str(finalObjective)+" to finally pay you a cruise Vacation!",
				])
				bulle.connect("text_done", self, "obj_buy_thing")
		else:
			displayAmountBriefly("Not enough money!", Color(1, 1, 1, 1), _objectPos)
			trigger_buy(null, false)

func obj_buy_thing():
	unpause()
	objective = "earn_"+str(finalObjective)
	
func displayAmountBriefly(_text, _color, _objectPos):
	var n2 = Node2D.new()
	var l = CustomLabel.instance()
	l.modulate = _color
	n2.add_child(l)
	add_child(n2)
	l.text = _text
	n2.scale = Vector2(1.5, 1.5)
	var tween = Tween.new()
	tween.interpolate_property(n2, "modulate",
		Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1.5,
		Tween.TRANS_QUART, Tween.EASE_IN)
	tween.interpolate_property(n2, "position",
		_objectPos, _objectPos + Vector2(0, -20), 1.5,
		Tween.TRANS_QUART, Tween.EASE_IN)
	n2.add_child(tween)
	tween.connect("tween_all_completed", self, "remove_brief_display", [n2])
	tween.start()
	
func remove_brief_display(node2d):
	node2d.queue_free()
