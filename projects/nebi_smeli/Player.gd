extends KinematicBody2D

export (int) var speed = 300
export (int) var jump_speed_up = 15
export (int) var jump_speed_down = 7
export (int) var jump_height = 100

enum JumpState { IDLE, JUMP_UP, JUMP_DOWN }
var jumpState = JumpState.IDLE

var velocity = Vector2()
var height = 0

var scale_jump = Vector2(1, 1)

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1	
		
	if Input.is_action_just_pressed("jump") and jumpState == JumpState.IDLE:
		jumpState = JumpState.JUMP_UP
		
	match(jumpState):
		JumpState.IDLE:
			pass
		JumpState.JUMP_UP:
			height += jump_speed_up
			if height >= jump_height:
				jumpState = JumpState.JUMP_DOWN
		JumpState.JUMP_DOWN:
			height -= jump_speed_down
			if height <= 0:
				height = 0
				jumpState = JumpState.IDLE
			
	var scale_fact = (float(height + jump_height) / float(jump_height))
	var scale_vec = scale_jump * scale_fact
	set_scale(scale_vec)
		
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)
	
