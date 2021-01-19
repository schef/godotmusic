extends Node
onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
onready var buttons : VBoxContainer = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons
onready var button : Button = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer/Buttons/Button

const SCROLL_SENSITIVITY = .03;
var mouse_button_down = false

func _ready() -> void:
	buttons.remove_child(button)
	for i in range(0, 20):
		var b = Button.new()
		b.text = "Masterclass " + str(i)
		b.rect_min_size = Vector2(0, 150)
		b.mouse_filter = Button.MOUSE_FILTER_PASS
		buttons.add_child(b)

func _gui_event(event):
	if (event is InputEventMouseButton and event.button_index == BUTTON_LEFT):
		mouse_button_down = event.pressed;
	if (event is InputEventMouseMotion and mouse_button_down):
		scroll_container.scroll_horizontal -= event.speed.x * SCROLL_SENSITIVITY
	if (event is InputEventScreenDrag):
		scroll_container.scroll_horizontal -= event.relative.x
