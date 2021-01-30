extends Node
onready var scroll_container = $ColorRect/MarginContainer/VBoxContainer/ScrollContainer
onready var title : Label = $Display/MarginContainer/VBoxContainer/Header/Title
onready var subtitle : Label = $Display/MarginContainer/VBoxContainer/Header/Subtitle
onready var scroll_array : VBoxContainer = $Display/MarginContainer/VBoxContainer/ScrollContainer/ScrollArray
var multiple_array = load("res://components/multiple_array.tscn")
var button = preload("res://components/button.tscn")
var label = preload("res://components/label.tscn")
	
const SCROLL_SENSITIVITY = .03;
var mouse_button_down = false

func generate_label(index: int, text: String):
	var l = label.instance()
	l.name = "LABEL_" + str(index)
	l.text = text
	return l

func generate_button(index: int, text: String, callback: String):
	var b = button.instance()
	b.text = text
	b.connect("pressed", self, callback, [index])
	return b
	
func generate_hbox(elements: Array):
	var ma = multiple_array.instance()
	for element in elements:
		ma.add_child(element)
	return ma

func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = find_node_by_name(child, name)
		if(found): return found
	return null

func set_label(index: int, text: String):
	var node = find_node_by_name(get_tree().get_root(), "LABEL_" + str(index))
	node.text = text

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
