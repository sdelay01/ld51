extends Node2D

var Background = preload("res://scenes/Decor/Background.tscn")
var Menu = preload("res://scenes/Menu.tscn")
var Salon = preload("res://scenes/Salon.tscn")
var menu
var salon

func _ready():
	#display_menu()
	on_game_start()

func display_menu():
	menu = Menu.instance()
	menu.scale = Vector2(2, 2)
	menu.connect("start", self, "on_game_start")
	add_child(menu)

func on_game_start():
	if menu: menu.queue_free()
	salon = Salon.instance()
	salon.scale = Vector2(2, 2)
	salon.connect("toggle_music", self, "on_toggle_music")
	add_child(salon)

func on_toggle_music():
	$AudioStreamPlayer.playing = !$AudioStreamPlayer.playing
