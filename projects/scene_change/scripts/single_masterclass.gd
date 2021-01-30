extends "res://scripts/template.gd"

var masterclass
enum ButtonIndex {BACK = -1}

func init():
	masterclass = Global.get_masterclass(Global.get_group_index())

func init_header():
	title.text = "Masterclass " + str(masterclass["group"])
	subtitle.text = masterclass["description"]

func init_buttons():
	scroll_array.add_child(generate_button(ButtonIndex.BACK, "<-", "on_button_pressed"))
	var buttonIndex = 0
	for practice in masterclass["practices"]:
		var text = "Practice " + str(practice["practice"])
		scroll_array.add_child(generate_button(buttonIndex, text, "on_button_pressed"))
		buttonIndex += 1

func on_button_pressed(index: int):
	match index:
		ButtonIndex.BACK:
			Global.reset_group_index()
			get_tree().change_scene("res://scenes/masterclasses.tscn")
		_:
			Global.set_practice_index(index)
			get_tree().change_scene("res://scenes/practice_meditation.tscn")
