extends "res://scripts/template.gd"

func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_subtitle()

func init_buttons():
	var buttonIndex = 0
	for masterclass in Global.get_masterclasses():
		var text = "Masterclass " + str(masterclass["group"])
		scroll_array.add_child(generate_button(buttonIndex, text, "on_button_pressed"))
		buttonIndex += 1

func on_button_pressed(index: int):
	Global.set_group_index(index)
	get_tree().change_scene("res://scenes/single_masterclass.tscn")
