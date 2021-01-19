extends Node

onready var touches_label : Label = $Container/VBoxContainer/Touches
onready var container : Container = $Container
onready var sampler : Multisampler = $Multisampler

var touch_count := 0
const sizeX = 1080
const sizeY = 1920
const buttonSpacingX = 10
const buttonSpacingY = 10
const buttonSpacingXStart = 10
const buttonSpacingYStart = 10
const buttonSizeX = (sizeX - buttonSpacingXStart * 2 - buttonSpacingX * 5) / 5
const buttonSizeY = (sizeY - buttonSpacingYStart * 2 - buttonSpacingY * 7) / 7
var buttons = []

func _ready() -> void:
	var theme = load("res://mytheme.tres")
	var x = buttonSpacingXStart
	var y = buttonSpacingYStart
	for i in range(0, 35):
		buttons.append(Button.new())
		buttons[-1].text = str(i)
		buttons[-1].theme = theme
		buttons[-1].set_size(Vector2(buttonSizeX, buttonSizeY))
		buttons[-1].set_position(Vector2(x, y))
		buttons[-1].connect("button_down", self, "on_button_state_change", [i, true])
		buttons[-1].connect("button_up", self, "on_button_state_change", [i, false])
		add_child(buttons[-1])
		x += buttonSizeX + buttonSpacingX
		if x + buttonSizeX > sizeX:
			x = buttonSpacingXStart
			y += buttonSizeY + buttonSpacingY

func _process(delta):
	return delta

func _input(event: InputEvent) -> void:
	pass

func calculate_midi(index: int):
	var midi
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
	return midi

func on_button_state_change(index: int, state: bool):
	print("button_index[" + str(index) + "][" + str(state) + "]" )
	var midi = calculate_midi(index)
	if (state):
		#sampler.play_note(calculator.get_note_name(midi), calculator.get_note_octave(midi))
		sampler.play_note(midi)
	else:
		sampler.release_note(midi)
