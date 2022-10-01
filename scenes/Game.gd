extends Node2D

var Background = preload("res://scenes/Decor/Background.tscn")
var Menu = preload("res://scenes/Menu.tscn")
var Salon = preload("res://scenes/Salon.tscn")
var menu
var salon

# Called when the node enters the scene tree for the first time.
func _ready():
	#display_menu()
	on_menu_start()
	
func display_menu():
	menu = Menu.instance()
	menu.scale = Vector2(2, 2)
	menu.connect("start", self, "on_menu_start")
	add_child(menu)

func on_menu_start():
	if menu: menu.queue_free()
	salon = Salon.instance()
	salon.scale = Vector2(2, 2)
	add_child(salon)
