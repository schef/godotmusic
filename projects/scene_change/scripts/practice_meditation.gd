extends "res://scripts/template.gd"

var practice
enum ElementIndex {
	BACK = -1
	REPEAT = 0,
	NEXT,
	PLAY_C,
	SKIP,
	CHALLENGE,
	CHALLENGE_STATUS,
	SCORE,
	SCORE_STATUS,
	}

func init():
	practice = Global.get_practice(Global.get_group_index(), Global.get_practice_index())

func init_header():
	title.text = "Practice %d.%d" % [Global.get_group_index(), Global.get_practice_index()]
	subtitle.text = practice["description"]

func init_buttons():
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	scroll_array.add_child(generate_hbox([
		generate_label(ElementIndex.CHALLENGE, "Challenge"),
		generate_label(ElementIndex.CHALLENGE_STATUS, "D"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_button(ElementIndex.REPEAT, "Repeat", "on_button_pressed"),
		generate_button(ElementIndex.NEXT, "Next", "on_button_pressed"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_button(ElementIndex.PLAY_C, "Play C", "on_button_pressed"),
		generate_button(ElementIndex.SKIP, "Skip", "on_button_pressed"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_label(ElementIndex.SCORE, "Score"),
		generate_label(ElementIndex.SCORE_STATUS, "3/20"),
		]))		
#	var ElementIndex = 0
#	for practice in masterclass["practices"]:
#		var text = "Practice " + str(practice["practice"])
#		scroll_array.add_child(generate_button(ElementIndex, text, "on_button_pressed"))
#		ElementIndex += 1

func on_button_pressed(index: int):
	match index:
		ElementIndex.BACK:
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/single_masterclass.tscn")
		_:
			set_label(ElementIndex.CHALLENGE_STATUS, str(index))
