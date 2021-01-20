extends KinematicBody2D

export (int) var speed = 150
export (int) var gajba = 20

var velocity = Vector2()

onready var area = get_node("Area2D")
onready var player = get_node("/root/World/Player")
onready var score_txt = get_node("/root/World/Score")
onready var soundPlayer = get_node("/root/World/BeerSoundPlayer")
onready var bgMusicPlayer = get_node("/root/World/Music")

var death_counter = 0

var time_start = 0

func _ready():
	bgMusicPlayer.play()
	time_start = OS.get_unix_time()

func die():
	death_counter += 1
	if death_counter < gajba:
		soundPlayer.play()
		position.x = rand_range(100, 800)
		position.y = rand_range(100, 440)
		score_txt.text = str(death_counter)
	elif death_counter == gajba:
		visible = false
		bgMusicPlayer.stop()
		var time = (OS.get_unix_time() - time_start)
		score_txt.text = str(time) + "s gajba!"
		position.x = 10000
		position.y = 10000
	else:
		pass
	
func _physics_process(delta):
	var direction_to_player = (player.position - position).normalized()
	velocity = direction_to_player * speed
	
	var distance = position.distance_to(player.position)
	
	if distance < 350:
		velocity = velocity.rotated(180)
		velocity = move_and_slide(velocity)
	elif distance > 400:
		velocity = move_and_slide(velocity * 0.5)
	else:
		velocity = move_and_slide(velocity * 0.01)
		
	if area.overlaps_body(player):
		die()
