extends "res://scripts/template.gd"

func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_description()

func init_scroll_array():
	var buttonIndex = 0
	for masterclass in Global.get_masterclasses():
		var text = Global.get_field_from_object(masterclass, "title")
		var btn = generate_button(buttonIndex, text, "on_button_pressed")
		if (Global.is_masterclass_finished(masterclass["id"])):
			btn.modulate = Color.green
		scroll_array.add_child(btn)
		buttonIndex += 1

func on_button_pressed(index: int):
	Global.set_masterclass_index(index)
	get_tree().change_scene("res://scenes/masterclass.tscn")
