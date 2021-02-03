extends Multisampler

const NOTE_DURATION = 1000
class NoteAction:
	var midi: int
	var status: bool
	var startTimestamp: int
	var timeout: int
	
var noteActionQueue = []

func _ready():
	var n = NoteSample.new()
	n.stream = preload("res://ogg/060.ogg")
	n.value = 60
	samples.append(n)

func getMillis():
	return OS.get_system_time_msecs()

func millisPassed(timestamp: int):
	return getMillis() - timestamp

func _process(delta):
	for n in noteActionQueue:
		if !n.status and getMillis() >= n.startTimestamp:
			n.status = true
			noteOn(n.midi)
		elif n.status and millisPassed(n.startTimestamp) >= n.timeout:
			n.status = false
			noteOff(n.midi)
	for i in range(len(noteActionQueue) - 1, -1, -1):
		var n = noteActionQueue[i]
		if !n.status and millisPassed(n.startTimestamp) >= n.timeout:
			noteActionQueue.remove(i)

func noteOn(note):
	print("noteOn[%d]" % [note])
	play_note(note)

func noteOff(note):
	print("noteOff[%d]" % [note])
	release_note(note)

func playMultipleNotesMelodicly(pitchList):
	print("playMultipleNotesMelodicly", pitchList)
	var currentTime = getMillis()
	for subPitchList in pitchList:
		for pitch in subPitchList:
			var n = NoteAction.new()
			n.midi = PitchParser.getMidiFromPitch(pitch)
			n.status = false
			n.startTimestamp = currentTime
			n.timeout = NOTE_DURATION
			currentTime = currentTime + NOTE_DURATION
			noteActionQueue.append(n)
		currentTime += NOTE_DURATION

func playMultipleNotesHarmonicly(pitchList):
	print("playMultipleNotesHarmonicly", pitchList)
	var currentTime = getMillis()
	for subPitchList in pitchList:
		for pitch in subPitchList:
			var n = NoteAction.new()
			n.midi = PitchParser.getMidiFromPitch(pitch)
			n.status = false
			n.startTimestamp = currentTime
			n.timeout = NOTE_DURATION
			noteActionQueue.append(n)
		currentTime += NOTE_DURATION

func allNotesOff():
	release_all()
