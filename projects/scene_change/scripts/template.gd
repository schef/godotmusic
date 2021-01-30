extends Node
onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
onready var title : Label = $Display/MarginContainer/VBoxContainer/Header/Title
onready var subtitle : Label = $Display/MarginContainer/VBoxContainer/Header/Subtitle
onready var scroll_array : VBoxContainer = $Display/MarginContainer/VBoxContainer/ScrollContainer/ScrollArray
var button = preload("res://components/button.tscn")
var label = preload("res://components/label.tscn")
	
const SCROLL_SENSITIVITY = .03;
var mouse_button_down = false

func generate_button(index: int, text: String, callback: String):
	var b = button.instance()
	b.text = text
	b.connect("pressed", self, callback, [index])
	return b

func _gui_event(event):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT):
		mouse_button_down = event.pressed;
	if (event is InputEventMouseMotion and mouse_button_down):
		scroll_container.scroll_horizontal -= event.speed.x * SCROLL_SENSITIVITY
	if (event is InputEventScreenDrag):
		scroll_container.scroll_horizontal -= event.relative.x

func init():
	pass

func init_header():
	pass

func init_buttons():
	pass

func _ready():
	init()
	init_header()
	init_buttons()
