extends Node2D

var screenSize: Vector2
var leftVerticalLine: float
var rightVerticalLine: float
var horizontalLine: float

enum FingerAction {PRESS, RELEASE, DRAG}
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

func _is_direction_used(direction: String):
	for key in fingerDict:
		if direction == fingerDict[key]:
			return true
	return false

func move_player(direction: String, fingerAction: int, fingerIndex: int):
	print("direction[%s], fingerAction[%s], fingerIndex[%s]" % [direction, fingerAction, fingerIndex])
	if (fingerIndex >= 2):
		return
	match fingerAction:
		FingerAction.PRESS:
			if (fingerDict[fingerIndex] == null and not _is_direction_used(direction)):
				fingerDict[fingerIndex] = direction
				Input.action_press(fingerDict[fingerIndex])
		FingerAction.DRAG:
			if (fingerDict[fingerIndex] != direction):
				Input.action_release(fingerDict[fingerIndex])
				fingerDict[fingerIndex] = direction
				Input.action_press(fingerDict[fingerIndex])
		FingerAction.RELEASE:
			if (fingerDict[fingerIndex] != null):
				Input.action_release(fingerDict[fingerIndex])
				fingerDict[fingerIndex] = null

func get_touch_location(position: Vector2) -> String:
		if position.x > (rightVerticalLine):
			return("move_right")
		elif position.x < (leftVerticalLine):
			return("move_left")
		else:
			if position.y < (horizontalLine):
				return("move_up")
			else:
				return("move_down")
				
func _input (event):
	var screenSize = get_viewport().get_visible_rect().size
	if event is InputEventScreenTouch:
		move_player(get_touch_location(event.position), FingerAction.PRESS if event.is_pressed() else FingerAction.RELEASE, event.index)
	elif event is InputEventScreenDrag:
		move_player(get_touch_location(event.position), FingerAction.DRAG, event.index)	
