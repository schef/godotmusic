extends "res://scripts/template.gd"

var batch
var score = 0
var keyboard

enum ElementIndex {
	BACK = -1
	NEXT = 0,
	PLAY_C,
	REPEAT,
	RESTART,
	DEBUG,
	DEBUG_LABEL,
	SCORE,
	SCORE_STATUS,
	}

func refresh_score():
	set_label(ElementIndex.SCORE_STATUS, "%d/%d" % [score, Global.get_field("maxHits")])

func play_question():
	MidiPlayer.playMultipleNotesHarmonicly(batch["question"])

func play_anwser():
	MidiPlayer.playMultipleNotesHarmonicly(batch["anwser"])
	
func show_debug():
	set_label(ElementIndex.DEBUG_LABEL, str(batch))

func hide_debug():
	set_label(ElementIndex.DEBUG_LABEL, "")

func next_batch():
	batch = Global.get_random_practice_batch()
	hide_debug()
	refresh_score()
	play_question()

func check_pitch_match(pitch_list):
	var anwser_list = Global.get_flat_pitch_list(Global.get_field_from_object(batch, "anwser"))
	for i in len(pitch_list):
		if pitch_list[i] != anwser_list[i]:
			return false
	return true

func on_key_press(pitch_list):
	if (len(pitch_list) == len(Global.get_flat_pitch_list(Global.get_field_from_object(batch, "anwser")))):
		if (check_pitch_match(pitch_list)):
			score += 1
			keyboard.clear_text(true)
			next_batch()
		else:
			keyboard.clear_text(false)
			score = 0
		refresh_score()
	
func _ready():
	keyboard = find_node_by_name(get_tree().get_root(), "Keyboard")
	keyboard.register_on_key_press_callback(self, "on_key_press")
	next_batch()

func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_description()

func init_scroll_array():
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	var keyboard = load("res://components/keyboard.tscn").instance()
	scroll_array.add_child(keyboard)
	scroll_array.add_child(generate_hbox([
		generate_button(ElementIndex.PLAY_C, "Play C", "on_button_pressed"),
		generate_button(ElementIndex.REPEAT, "Repeat", "on_button_pressed"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_button(ElementIndex.RESTART, "Restart", "on_button_pressed"),
		generate_button(ElementIndex.DEBUG, "Debug", "on_button_pressed"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_label(ElementIndex.SCORE, "Score"),
		generate_label(ElementIndex.SCORE_STATUS, "3/20"),
		]))
	var debug_label = generate_label(ElementIndex.DEBUG_LABEL, "")
	debug_label.theme = load("res://assets/font_small.tres")
	debug_label.autowrap = true
	scroll_array.add_child(debug_label)

func on_button_pressed(index: int):
	match index:
		ElementIndex.BACK:
			Global.set_score(score)
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/masterclass.tscn")
		ElementIndex.REPEAT:
			play_question()
		ElementIndex.PLAY_C:
			MidiPlayer.playMultipleNotesHarmonicly([["c'"]])
		ElementIndex.RESTART:
			score = 0
			next_batch()
		ElementIndex.DEBUG:
			show_debug()
