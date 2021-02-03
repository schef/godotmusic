extends "res://scripts/template.gd"

var practice
var batch_select
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
	set_label(ElementIndex.SCORE_STATUS, "%d/%d" % [score, practice["maxHits"]])

func play_question():
	MidiPlayer.playMultipleNotesHarmonicly(batch_select["question"])

func play_anwser():
	MidiPlayer.playMultipleNotesHarmonicly(batch_select["anwser"])
	
func show_debug():
	set_label(ElementIndex.DEBUG_LABEL, str(batch_select))

func hide_debug():
	set_label(ElementIndex.DEBUG_LABEL, "")

func get_linear_anwser_pitch_list():
	var pitchList = []
	for b in batch_select["anwser"]:
		for p in b:
			pitchList.append(PitchParser.getPitchBase(p))
	return pitchList

func next_batch():
	batch_select = Global.get_random_practice_batch(practice)
	hide_debug()
	refresh_score()
	play_question()

func check_pitch_match(pitchList):
	var anwserList = get_linear_anwser_pitch_list()
	for i in len(pitchList):
		if pitchList[i] != anwserList[i]:
			return false
	return true

func on_key_press(pitchList):
	if (len(pitchList) == len(get_linear_anwser_pitch_list())):
		if (check_pitch_match(pitchList)):
			score += 1
			next_batch()
		else:
			score = 0
		keyboard.clear_text()
		refresh_score()
	
func init():
	practice = Global.get_practice(Global.get_group_index(), Global.get_practice_index())
	
func _ready():
	keyboard = find_node_by_name(get_tree().get_root(), "Keyboard")
	keyboard.register_on_key_press_callback(self, "on_key_press")
	next_batch()

func init_header():
	var masterclass = Global.get_masterclass(Global.get_group_index())
	var group_id = masterclass["group"]
	var practice_id = practice["practice"]
	title.text = "Practice %d.%d" % [group_id, practice_id]
	subtitle.text = practice["description"]

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
			Global.reset_practice_index()
			get_tree().change_scene("res://scenes/single_masterclass.tscn")
		ElementIndex.REPEAT:
			play_question()
		ElementIndex.PLAY_C:
			MidiPlayer.playMultipleNotesHarmonicly([["c'"]])
		ElementIndex.RESTART:
			score = 0
			next_batch()
		ElementIndex.DEBUG:
			show_debug()
