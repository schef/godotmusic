extends Node
onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
onready var masterclass = Global.get_masterclass(Global.get_group_index())
const SCROLL_SENSITIVITY = .03;
var mouse_button_down = false

func init_header():
	var title : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Title
	var subtitle : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Subtitle
	var version : Label = $ColorRect/MarginContainer/VBoxContainer/Header/Version
	title.text = "Masterclass " + str(masterclass["group"])
	subtitle.text = masterclass["description"].replace(". ", ".\n")
	version.text = ""
	
func init_buttons():
	var buttons : VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons
	var button : Button = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons/Button
	buttons.remove_child(button)
	var b = Button.new()
	b.connect("pressed", self, "on_button_pressed", [255])
	b.text = "<-"
	b.rect_min_size = Vector2(0, 150)
	b.mouse_filter = Button.MOUSE_FILTER_PASS
	buttons.add_child(b)
	var buttonIndex = 0
	for practice in masterclass["practices"]:
		b = Button.new()
		b.connect("pressed", self, "on_button_pressed", [buttonIndex])
		b.text = "Practice " + str(practice["practice"])
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
	if index == 255:
		Global.reset_group_index()
		get_tree().change_scene("res://scenes/first_screen.tscn")
	else:
		Global.set_practice_index(index)
		get_tree().change_scene("res://scenes/PITCH_NAMING_DRILL.tscn")
