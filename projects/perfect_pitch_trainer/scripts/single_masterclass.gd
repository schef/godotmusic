extends "res://scripts/template.gd"

var masterclass
enum ElementIndex {BACK = -1}

func init():
	masterclass = Global.get_masterclass(Global.get_group_index())

func init_header():
	title.text = "Masterclass " + str(masterclass["group"])
	subtitle.text = masterclass["description"]

func init_scroll_array():
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	var ElementIndex = 0
	for practice in masterclass["practices"]:
		var text = "Practice " + str(practice["practice"])
		scroll_array.add_child(generate_button(ElementIndex, text, "on_button_pressed"))
		ElementIndex += 1

func on_button_pressed(index: int):
	match index:
		ElementIndex.BACK:
			Global.reset_group_index()
			get_tree().change_scene("res://scenes/masterclasses.tscn")
		_:
			Global.set_practice_index(index)
			var practice = Global.get_practice(Global.get_group_index(), Global.get_practice_index())
			var scene_path = "res://scenes/practice_" + practice["practiceType"].to_lower() + ".tscn"
			get_tree().change_scene(scene_path)
