extends Node2D

var screenSize: Vector2
var leftVerticalLine: float
var rightVerticalLine: float
var upHorizontalLine: float
var downHorizontalLine: float

enum FingerAction {PRESS, RELEASE, DRAG}
var fingerDict = {
	0 : null,
	1 : null,
}

func _draw():
	screenSize = get_viewport().get_visible_rect().size	
	leftVerticalLine = screenSize.x * 0.125
	rightVerticalLine = screenSize.x * 0.875
	upHorizontalLine = screenSize.y * 0.5
	downHorizontalLine = screenSize.y * 0.75
	draw_line(Vector2(leftVerticalLine,upHorizontalLine), Vector2(leftVerticalLine, screenSize.y), Color(255, 0, 0), 3)
	draw_line(Vector2(rightVerticalLine,upHorizontalLine), Vector2(rightVerticalLine, screenSize.y), Color(255, 0, 0), 3)
	draw_line(Vector2(0,upHorizontalLine), Vector2(screenSize.x, upHorizontalLine), Color(255, 0, 0), 3)
	draw_line(Vector2(leftVerticalLine,downHorizontalLine), Vector2(rightVerticalLine, downHorizontalLine), Color(255, 0, 0), 3)
	
func _ready():
	update()
	pass # Replace with function body.
	
func move_player(direction: String, fingerAction: int, fingerIndex: int):
	print("direction[%s], fingerAction[%s], fingerIndex[%s]" % [direction, fingerAction, fingerIndex])
	if (fingerIndex >= 2):
		return
	match fingerAction:
		FingerAction.PRESS:
			if (fingerDict[fingerIndex] == null):
				fingerDict[fingerIndex] = direction
				Input.action_press(fingerDict[fingerIndex])
		FingerAction.DRAG:
			if (fingerDict[fingerIndex] != direction and fingerDict[fingerIndex] != null):
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
			if position.y > (upHorizontalLine) and position.y <= (downHorizontalLine):
				return("move_up")
			elif position.y > downHorizontalLine:
				return("move_down")
		return ""
				
func _input (event):
	var screenSize = get_viewport().get_visible_rect().size
	if event is InputEventScreenTouch:
		move_player(get_touch_location(event.position), FingerAction.PRESS if event.is_pressed() else FingerAction.RELEASE, event.index)
	elif event is InputEventScreenDrag:
		move_player(get_touch_location(event.position), FingerAction.DRAG, event.index)		
