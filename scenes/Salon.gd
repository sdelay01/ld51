extends Node2D

var Background = preload("res://scenes/Decor/Background.tscn")
var Chair = preload("res://scenes/Decor/Chair.tscn")
var Mirror = preload("res://scenes/Decor/Mirror.tscn")
var Seat = preload("res://scenes/Decor/Seat.tscn")
var Haircut25 = preload("res://scenes/Decor/Haircut25.tscn")
var Money = preload("res://scenes/Blocs/Money.tscn")
var money

var Buy = preload("res://scenes/Blocs/Buy.tscn")
var buy
var Pause = preload("res://scenes/Blocs/Pause.tscn")
var pause

var Customer = preload("res://scenes/Customer.tscn")
var customers = []
var Counter = preload("res://scenes/Counter.tscn")
var counter
var Eugene = preload("res://scenes/Eugene.tscn")
var eugene

var chairs = []
var seats = []

func _ready():
	var bg = Background.instance()
	add_child(bg)
	var h25 = Haircut25.instance()
	h25.position = Vector2(280, 50)
	add_child(h25)
	
	add_chair(1)
	add_chair(2) # TODO when buying
	add_seat(1)
	add_seat(2) # TODO when buying
	
	eugene = Eugene.instance()
	add_child(eugene)
	eugene.position = Vector2(100, 210)
	eugene.scale = Vector2(2, 2)

	add_customer()
	
	counter = Counter.instance()
	counter.connect("timeout", self, "on_counter_timeout")
	add_child(counter)
	
	money = Money.instance()
	money.setAmount(152)
	add_child(money)
	
	buy = Buy.instance()
	add_child(buy)
	
	pause = Pause.instance()
	add_child(pause)

func on_counter_timeout():
	add_customer()
	
func add_customer():
	var c = Customer.instance()
	c.connect("cut_done", eugene, "on_cut_done")
	customers.push_back(c)
	add_child(c)
	c.init(self)
	
func get_next_chair():
	for c in chairs:
		print("chair", c)
		if c.isFree: return c
	return false

func get_next_seat():
	for s in seats:
		if s.isFree: return s
	return false

func add_chair(rank):
	var m = Mirror.instance()
	add_child(m)
	m.position = Vector2(rank * 120 - 100, 60)
	
	var c = Chair.instance()
	add_child(c)
	c.position = Vector2(rank * 120 - 100, 120)
	chairs.push_back(c)

func add_seat(rank):
	var s = Seat.instance()
	s.position = Vector2(160 + rank * 64, 100)
	add_child(s)
	seats.push_back(s)
