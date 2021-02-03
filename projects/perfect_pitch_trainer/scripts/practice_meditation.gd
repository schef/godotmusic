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
	DEBUG_LABEL,
	DEBUG
	}

func get_random_practice_batch():
	return practice["practiceBatch"][Global.get_random_number_in_range(0, len(practice["practiceBatch"]) - 1)]

func show_score():
	set_label(ElementIndex.SCORE_STATUS, "%d/%d" % [score, practice["maxHits"]])

func show_question():
	var questions = []
	for batch in batch_select["question"]:
		questions.append(PoolStringArray(batch).join(", "))
	var question = PoolStringArray(questions).join("\n")
	set_label(ElementIndex.CHALLENGE_STATUS, question)

func play_question():
	MidiPlayer.playMultipleNotesHarmonicly(batch_select["question"])

func play_anwser():
	MidiPlayer.playMultipleNotesHarmonicly(batch_select["anwser"])

func show_debug():
	set_label(ElementIndex.DEBUG_LABEL, str(batch_select))

func hide_debug():
	set_label(ElementIndex.DEBUG_LABEL, "")

func next_batch():
	batch_select = get_random_practice_batch()
	hide_debug()
	show_score()
	show_question()
	
func init():
	practice = Global.get_practice(Global.get_group_index(), Global.get_practice_index())

func _ready():
	next_batch()

func init_header():
	var masterclass = Global.get_masterclass(Global.get_group_index())
	var group_id = masterclass["group"]
	var practice_id = practice["practice"]
	title.text = "Practice %d.%d" % [group_id, practice_id]
	subtitle.text = practice["description"]

func init_scroll_array():
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
		generate_button(ElementIndex.DEBUG, "Debug", "on_button_pressed")
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
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/single_masterclass.tscn")
		ElementIndex.CHECK:
			play_anwser()
		ElementIndex.NEXT:
			score += 1
			next_batch()
		ElementIndex.PLAY_C:
			MidiPlayer.playMultipleNotesHarmonicly([["c'"]])
		ElementIndex.RESTART:
			score = 0
			next_batch()
		ElementIndex.DEBUG:
			show_debug()
