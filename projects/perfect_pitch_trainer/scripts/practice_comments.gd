extends "res://scripts/template.gd"

var comments

enum ElementIndex {
	BACK = -1
	COMMENTS = 0,
	}

func init():
	comments = load("res://components/comment.tscn").instance()
	
func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_description()

func init_scroll_array():
	comments.bbcode_text = Global.get_field("text")
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	scroll_array.add_child(comments)

func on_button_pressed(index: int):
	match index:
		ElementIndex.BACK:
			Global.set_score(1)
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/masterclass.tscn")
