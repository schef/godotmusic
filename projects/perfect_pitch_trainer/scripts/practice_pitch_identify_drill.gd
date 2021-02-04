extends "res://scripts/template.gd"

var batch
var score = 0

enum ElementIndex {
	BACK = -1
	CHECK = 0,
	NEXT,
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
	
func _ready():
	next_batch()

func init_header():
	title.text = Global.get_title()
	subtitle.text = Global.get_description()

func init_scroll_array():
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	scroll_array.add_child(generate_hbox([
		generate_button(ElementIndex.CHECK, "Check", "on_button_pressed"),
		generate_button(ElementIndex.NEXT, "Next", "on_button_pressed"),
		]))
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
		ElementIndex.CHECK:
			play_anwser()
		ElementIndex.NEXT:
			score += 1
			next_batch()
		ElementIndex.REPEAT:
			play_question()
		ElementIndex.PLAY_C:
			MidiPlayer.playMultipleNotesHarmonicly([["c'"]])
		ElementIndex.RESTART:
			score = 0
			next_batch()
		ElementIndex.DEBUG:
			show_debug()
