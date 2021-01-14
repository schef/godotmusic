#!/usr/bin/env python

_audiostream_id = 6
_subresource_id = 1
_midi = 21

_audiostream_text = []
_subresource_text = []
_samples_text = []

_pitches = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
_currentPitch = 9
_octave = 1

def generateAudioStreamText():
    global _audiostream_text
    global _audiostream_id
    global _midi
    text = "[ext_resource path=\"res://ogg/%03d.ogg\" type=\"AudioStream\" id=%d]" % (_midi, _audiostream_id)
    _audiostream_text.append(text)

def generateSubresourceText():
    global _subresource_id
    global _audiostream_id
    global _subresource_text
    global _pitches
    global _currentPitch
    global _octave
    string = ""
    string += "[sub_resource type=\"Resource\" id=%d]\n" % (_subresource_id)
    string += "script = ExtResource( 4 )\n"
    string += "stream = ExtResource( %d )\n" % (_audiostream_id)
    string += "tone = \"%s\"\n" % (_pitches[_currentPitch])
    string += "octave = %d\n" % (_octave)
    _subresource_text.append(string)


def generateSamplesText():
    global _subresource_id
    global _samples_text
    text = "SubResource( %d )" % (_subresource_id)
    _samples_text.append(text)

def incrementPitch():
    global _pitches
    global _currentPitch
    global _octave
    try:
        _currentPitch += 1
        _pitches[_currentPitch]
    except:
        _currentPitch = 0
        _octave += 1


for i in range(_midi, 109):
    generateAudioStreamText()
    generateSubresourceText()
    generateSamplesText()
    incrementPitch()
    _audiostream_id += 1
    _subresource_id += 1
    _midi += 1

print("\n".join(_audiostream_text))
print()
print("\n".join(_subresource_text))
print("samples = [ " + ", ".join(_samples_text) + "] ")
