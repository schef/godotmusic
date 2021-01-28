extends Node
onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
onready var title : Label = $Display/MarginContainer/VBoxContainer/Header/Title
onready var subtitle : Label = $Display/MarginContainer/VBoxContainer/Header/Subtitle
onready var scroll_array : VBoxContainer = $Display/MarginContainer/VBoxContainer/ScrollContainer/ScrollArray
var button = preload("res://components/button.tscn")
var label = preload("res://components/label.tscn")
	
const SCROLL_SENSITIVITY = .03;
var mouse_button_down = false

func on_button_pressed(index: int):
	Global.set_group_index(index)
	get_tree().change_scene("res://scenes/second_screen.tscn")

func generate_button(index: int, text: String):
	var b = button.instance()
	b.text = text
	b.connect("pressed", self, "on_button_pressed", [index])
	return b

func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_subtitle()

func init_buttons():
	var buttonIndex = 0
	for masterclass in Global.get_masterclasses():
		var text = "Masterclass " + str(masterclass["group"])
		scroll_array.add_child(generate_button(buttonIndex, text))
		buttonIndex += 1
		
func _ready() -> void:
	init_header()
	init_buttons()

func _gui_event(event):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT):
		mouse_button_down = event.pressed;
	if (event is InputEventMouseMotion and mouse_button_down):
		scroll_container.scroll_horizontal -= event.speed.x * SCROLL_SENSITIVITY
	if (event is InputEventScreenDrag):
		scroll_container.scroll_horizontal -= event.relative.x
