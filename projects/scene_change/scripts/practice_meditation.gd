extends "res://scripts/template.gd"

var practice
enum ButtonIndex {BACK = -1}

func init():
	practice = Global.get_practice(Global.get_group_index(), Global.get_practice_index())

func init_header():
	title.text = "Practice %d.%d" % [Global.get_group_index(), Global.get_practice_index()]
	subtitle.text = practice["description"]

func init_buttons():
	scroll_array.add_child(generate_button(ButtonIndex.BACK, "<-", "on_button_pressed"))
#	var buttonIndex = 0
#	for practice in masterclass["practices"]:
#		var text = "Practice " + str(practice["practice"])
#		scroll_array.add_child(generate_button(buttonIndex, text, "on_button_pressed"))
#		buttonIndex += 1

func on_button_pressed(index: int):
	match index:
		ButtonIndex.BACK:
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/single_masterclass.tscn")
		_:
			pass
