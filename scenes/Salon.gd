extends Node2D

var Background = preload("res://scenes/Decor/Background.tscn")
var Chair = preload("res://scenes/Decor/Chair.tscn")
var Mirror = preload("res://scenes/Decor/Mirror.tscn")
var Seat = preload("res://scenes/Decor/Seat.tscn")
var Haircut25 = preload("res://scenes/Decor/Haircut25.tscn")

var Customer = preload("res://scenes/Customer.tscn")

var Eugene = preload("res://scenes/Eugene.tscn")
var eugene

var chairs = []
var seats = []
var customers = []

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

func add_customer():
	var c = Customer.instance()
	c.connect("need_letter", eugene, "_on_need_letter")
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
	m.position = Vector2(rank * 64, 60)
	
	var c = Chair.instance()
	add_child(c)
	c.position = Vector2(rank * 64, 120)
	chairs.push_back(c)

func add_seat(rank):
	var s = Seat.instance()
	s.position = Vector2(160 + rank * 64, 100)
	add_child(s)
	seats.push_back(s)
