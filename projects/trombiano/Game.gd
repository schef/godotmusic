extends Node

onready var touches_label : Label = $Container/VBoxContainer/Touches
onready var container : Container = $Container
onready var sampler : Multisampler = $Multisampler
onready var calculator: NoteValueCalculator = $NoteValueCalculator

var touch_count := 0
const sizeX = 1080
const sizeY = 1920
const buttonSpacingX = 10
const buttonSpacingY = 10
const buttonSpacingXStart = 100
const buttonSpacingYStart = 100
const buttonSizeX = (sizeX - buttonSpacingXStart * 2 - buttonSpacingX * 5) / 5
const buttonSizeY = (sizeY - buttonSpacingYStart * 2 - buttonSpacingY * 7) / 7
var buttons = []

func _ready() -> void:
	update_touches_label()
	var x = buttonSpacingXStart
	var y = buttonSpacingYStart
	for i in range(0, 35):
		buttons.append(Button.new())
		buttons[-1].text = str(i)
		buttons[-1].set_size(Vector2(buttonSizeX, buttonSizeY))
		buttons[-1].set_position(Vector2(x, y))
		buttons[-1].connect("pressed", self, "_button_pressed", [i])
		add_child(buttons[-1])
		x += buttonSizeX + buttonSpacingX
		if x + buttonSizeX > sizeX:
			x = buttonSpacingXStart
			y += buttonSizeY + buttonSpacingY

func _input(event: InputEvent) -> void:
	if is_screen_touch(event) or is_mouse_left_click(event):
		touch_count += 1
		update_touches_label()

func is_screen_touch(event) -> bool:
	return event.is_pressed() and event is InputEventScreenTouch

func is_mouse_left_click(event) -> bool:
	if (event.is_pressed()):
		if (event is InputEventMouseButton):
			if (event.button_index == BUTTON_LEFT):
				return true
	return false

func update_touches_label() -> void:
	touches_label.text = str(touch_count)

func _button_pressed(index: int):
	print("button_index[" + str(index) + "]")
	var midi = 60
	if (index % 5 == 0):
		midi = 46 - int((index) / 5)
	elif (index % 5 == 1):
		midi = 53 - int((index) / 5)		
	elif (index % 5 == 2):
		midi = 58 - int((index) / 5)	
	elif (index % 5 == 3):
		midi = 62 - int((index) / 5)	
	elif (index % 5 == 4):
		midi = 65 - int((index) / 5)
	sampler.play_note(calculator.get_note_name(midi), calculator.get_note_octave(midi))	
