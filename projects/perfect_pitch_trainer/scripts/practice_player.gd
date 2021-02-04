extends "res://scripts/template.gd"

enum ElementIndex {
	BACK = -1
	LINK = 0,
	}

func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_description()

func init_scroll_array():
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	scroll_array.add_child(generate_button(ElementIndex.LINK, "Click to listen", "on_button_pressed"))

func on_button_pressed(index: int):
	match index:
		ElementIndex.BACK:
			Global.set_score(1)
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/masterclass.tscn")
		ElementIndex.LINK:
			 OS.shell_open(Global.get_field("link"))
