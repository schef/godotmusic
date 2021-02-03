extends "res://scripts/template.gd"

var practice
var batch_select
var score = 0

enum ElementIndex {
	BACK = -1
	CHECK = 0,
	NEXT,
	PLAY_C,
	RESTART,
	CHALLENGE,
	CHALLENGE_STATUS,
	SCORE,
	SCORE_STATUS,
	}

func get_random_practice_batch():
	return practice["practiceBatch"][Global.get_random_number_in_range(0, len(practice["practiceBatch"]) - 1)]

func show_score():
	set_label(ElementIndex.SCORE_STATUS, "%d/%d" % [score, practice["maxHits"]])

func show_question():
	set_label(ElementIndex.CHALLENGE_STATUS, str(batch_select["question"]))

func play_question():
	MidiPlayer.playMultipleNotesHarmonicly(batch_select["question"])

func play_anwser():
	MidiPlayer.playMultipleNotesHarmonicly(batch_select["question"])

func next_batch():
	batch_select = get_random_practice_batch()
	show_score()
	show_question()
	
func init():
	practice = Global.get_practice(Global.get_group_index(), Global.get_practice_index())

func _ready():
	next_batch()

func init_header():
	title.text = "Practice %d.%d" % [Global.get_group_index(), Global.get_practice_index()]
	subtitle.text = practice["description"]

func init_buttons():
	scroll_array.add_child(generate_button(ElementIndex.BACK, "<-", "on_button_pressed"))
	scroll_array.add_child(generate_hbox([
		generate_label(ElementIndex.CHALLENGE, "Sing"),
		generate_label(ElementIndex.CHALLENGE_STATUS, "D"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_button(ElementIndex.CHECK, "Check", "on_button_pressed"),
		generate_button(ElementIndex.NEXT, "Next", "on_button_pressed"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_button(ElementIndex.PLAY_C, "Play C", "on_button_pressed"),
		generate_button(ElementIndex.RESTART, "Restart", "on_button_pressed"),
		]))
	scroll_array.add_child(generate_hbox([
		generate_label(ElementIndex.SCORE, "Score"),
		generate_label(ElementIndex.SCORE_STATUS, "3/20"),
		]))

func on_button_pressed(index: int):
	match index:
		ElementIndex.BACK:
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/single_masterclass.tscn")
		ElementIndex.CHECK:
			play_anwser()
		ElementIndex.NEXT:
			score += 1
			next_batch()
		ElementIndex.PLAY_C:
			#MidiPlayer.playMultipleNotesHarmonicly([["c'"]])
			#MidiPlayer.playMultipleNotesHarmonicly([["c'"], ["c,", "c'", "c''"]])
			MidiPlayer.playMultipleNotesMelodicly([["c'"], ["c,", "c'", "c''"]])
		ElementIndex.RESTART:
			score = 0
			next_batch()
		_:
			set_label(ElementIndex.CHALLENGE_STATUS, str(index))
