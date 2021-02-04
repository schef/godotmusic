extends "res://scripts/template.gd"

enum ElementIndex {BACK = -1}

func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_description()

func init_scroll_array():
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	var ElementIndex = 0
	for practice in Global.get_practices():
		var text = Global.get_field_from_object(practice, "title")
		var btn = generate_button(ElementIndex, text, "on_button_pressed")
		if (Global.is_practice_finished(Global.get_field("id"), practice["id"])):
			btn.modulate = Color.green
		scroll_array.add_child(btn)
		ElementIndex += 1

func on_button_pressed(index: int):
	match index:
		ElementIndex.BACK:
			Global.reset_masterclass_index()
			get_tree().change_scene("res://scenes/root.tscn")
		_:
			Global.set_practice_index(index)
			var scene_path = "res://scenes/practice_%s.tscn" % [Global.get_field("practiceType").to_lower()]
			get_tree().change_scene(scene_path)
