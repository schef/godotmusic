extends Node
onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
onready var practice = Global.get_practice(Global.get_group_index(), Global.get_practice_index())
const SCROLL_SENSITIVITY = .03;
var mouse_button_down = false

func init_header():
	var title : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Title
	var subtitle : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Subtitle
	var version : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Version
	title.text = "Masterclass " + str(Global.get_group_index()) + "." +  str(Global.get_practice_index())
	subtitle.text = practice["description"].replace(". ", ".\n")
	version.text = ""

func generateButton(index: int, text: String):
	var b = Button.new()
	b.connect("pressed", self, "on_button_pressed", [index])
	b.text = text
	b.rect_min_size = Vector2(0, 150)
	b.mouse_filter = Button.MOUSE_FILTER_PASS
	return b

func generateLabel(text: String):
	var l = Label.new()
	l.text = text
	l.align = Label.ALIGN_CENTER
	return l

func init_buttons():
	var buttons : VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons
	var button : Button = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons/Button
	buttons.remove_child(button)
	buttons.add_child(generateButton(255, "<-"))
	buttons.add_child(generateLabel("PRACTICE: C"))
	buttons.add_child(generateButton(0, "Repeat"))
	buttons.add_child(generateButton(1, "Next"))
	buttons.add_child(generateButton(2, "Play C"))
	buttons.add_child(generateButton(3, "Skip"))
	buttons.add_child(generateLabel("STATUS: 16/30"))

		
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
	if index == 255:
		Global.reset_practice_index()
		get_tree().change_scene("res://scenes/second_screen.tscn")
	else:
		pass
