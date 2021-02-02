extends Node

const MIDI_BASE = 48
var re

var pitchMidiBase = {
	"c": 0,
	"cis": 1,
	"d": 2,
	"dis": 3,
	"e": 4,
	"f": 5,
	"fis": 6,
	"g": 7,
	"gis": 8,
	"a": 9,
	"ais": 10,
	"h": 11,
	"des": 1,
	"es": 3,
	"ges": 6,
	"as": 8,
	"b": 10,
}

func _ready():
	re = RegEx.new()
	re.compile('[\',]')

func isMidiPitch(midi, pitch):
	pitch = re.sub(pitch, '', true)
	return midi % 12 == pitchMidiBase[pitch]

func getPitchBase(pitch):
	pitch = re.sub(pitch, '', true)
	return pitch

func getOctaveFromPitch(pitch):
	var octave = 0
	for i in pitch:
		if i == "'":
			octave += 1
		elif i == ",":
			octave -= 1
	return MIDI_BASE + octave * 12

func getMidiFromPitch(pitch):
	var octave = getOctaveFromPitch(pitch)
	pitch = re.sub(pitch, '', true)
	return pitchMidiBase[pitch] + octave

func getOctaveFromMidi(midi):
	var rest = midi % 12
	var center = int(MIDI_BASE / 12)
	var octave = int((midi - rest) / 12)
	var centerOctave = (octave - center)
	if centerOctave > 0:
		return "'" * centerOctave
	elif centerOctave < 0:
		#TODO: check if here is , as number
		var returnString = ""
		for i in range(abs(centerOctave)):
			returnString += ","
		return returnString
	else:
		return ""

func getPitchFromMidi(midi):
	var octave = getOctaveFromMidi(midi)
	for name in pitchMidiBase:
		var midiBase = pitchMidiBase[name]
		if midiBase == midi % 12:
			return name + octave
	return ''

func getMidiListFromPitchList(pitchList):
	var midiList = []
	for pitch in pitchList:
		midiList.append(getMidiFromPitch(pitch))
	return midiList
	
func getMidiBaseFromMidi(midi):
	return midi % 12
	
func getMidiBaseFromPitch(pitch):
	var midi = getMidiFromPitch(pitch)
	return getMidiBaseFromMidi(midi)
