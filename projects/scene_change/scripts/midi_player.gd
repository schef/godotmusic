extends Multisampler

const NOTE_DURATION = 1

func _ready():
	print("ready")	
	var n = NoteSample.new()
	n.stream = preload("res://ogg/060.ogg")
	n.value = 60
	samples.append(n)

func _process(delta):
	pass

func noteOn(note):
	print("noteOn", note)
	play_note(note)

func noteOff(note):
	print("noteOff", note)
	release_note(note)

func playMultipleNotesMelodicly(pitchList):
	print("playMultipleNotesMelodicly", pitchList)
	var pitchListCopy = [] + pitchList
	var pitch = pitchListCopy.pop(0)
	var midi = PitchParser.getMidiFromPitch(pitch)
	noteOn(midi)
	var timer = Timer.new()
	timer.set_wait_time(NOTE_DURATION)
	timer.connect("timeout", self, "NoteOff", [midi])
	timer.start()
	if len(pitchListCopy) > 0:
		var timer2 = Timer.new()
		timer2.set_wait_time(NOTE_DURATION)
		timer2.connect("timeout", self, "playMultipleNotesMelodicly", [pitchListCopy])
		timer2.start()

func playMultipleNotesHarmonicly( pitchList):
	print("playMultipleNotesHarmonicly", pitchList)
	for pitch in pitchList:
		var midi = PitchParser.getMidiFromPitch(pitch)
		noteOn(midi)
		var timer = Timer.new()
		timer.set_wait_time(NOTE_DURATION)
		timer.connect("timeout", self, "NoteOff", [midi])
		timer.start()

func allNotesOff():
	release_all()
