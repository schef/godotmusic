extends Node2D

var screenSize: Vector2
var leftVerticalLine: float
var rightVerticalLine: float
var horizontalLine: float

var fingerDict = {
	0 : null,
	1 : null,
}

func _draw():
	screenSize = get_viewport().get_visible_rect().size	
	leftVerticalLine = screenSize.x * 0.125
	rightVerticalLine = screenSize.x * 0.875
	horizontalLine = screenSize.y * 0.75
	draw_line(Vector2(leftVerticalLine,0), Vector2(leftVerticalLine, screenSize.y), Color(255, 0, 0), 3)
	draw_line(Vector2(rightVerticalLine,0), Vector2(rightVerticalLine, screenSize.y), Color(255, 0, 0), 3)
	draw_line(Vector2(leftVerticalLine,horizontalLine), Vector2(rightVerticalLine, horizontalLine), Color(255, 0, 0), 3)
	
func _ready():
	update()
	pass # Replace with function body.
	
func move_player(direction: String, action: bool, fingerIndex: int):
	print("%s, %s, %s" % [direction, action, fingerIndex])
	if (fingerIndex >= 2):
		return
	if (action):
		if (fingerDict[fingerIndex] == null):
			fingerDict[fingerIndex] = direction
			Input.action_press(fingerDict[fingerIndex])
	else:
		Input.action_release(fingerDict[fingerIndex])
		fingerDict[fingerIndex] = null

func _input (event):
	var screenSize = get_viewport().get_visible_rect().size
	if event is InputEventScreenTouch:	
		if event.position.x > (rightVerticalLine):
			move_player("move_right", event.is_pressed(), event.index)
		elif event.position.x < (leftVerticalLine):
			move_player("move_left", event.is_pressed(), event.index)
		else:
			if event.position.y < (horizontalLine):
				move_player("move_up", event.is_pressed(), event.index)
			else:
				move_player("move_down", event.is_pressed(), event.index)
