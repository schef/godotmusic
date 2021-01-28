extends Node
onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer

const SCROLL_SENSITIVITY = .03;
var mouse_button_down = false

func init_header():
	var title : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Title
	var subtitle : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Subtitle
	var version : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Version
	title.text = Global.get_title()
	subtitle.text = Global.get_subtitle()
	version.text = Global.get_version()
	
func init_buttons():
	var buttons : VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons
	var button : Button = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons/Button
	buttons.remove_child(button)
	var buttonIndex = 0
	for masterclass in Global.get_masterclasses():
		var b = Button.new()
		b.connect("pressed", self, "on_button_pressed", [buttonIndex])
		b.text = "Masterclass " + str(masterclass["group"])
		b.rect_min_size = Vector2(0, 150)
		b.mouse_filter = Button.MOUSE_FILTER_PASS
		buttons.add_child(b)
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

func on_button_pressed(index: int):
	Global.set_group_index(index)
	get_tree().change_scene("res://scenes/second_screen.tscn")
