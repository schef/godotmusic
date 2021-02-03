extends Sampler
class_name Multisampler

export(int) var max_notes:= 4

var samplers := []
var next_available = 0

func _ready():
	# Create samplers
	# warning-ignore:unused_variable
	for i in range(max_notes):
		var sampler := Sampler.new()
		sampler.samples = samples
		sampler.attack = attack
		sampler.sustain = sustain
		sampler.release = release
		sampler.volume_db = volume_db
		sampler.bus = bus

		add_child(sampler)
		samplers.append(sampler)

#func play_note(note: String, octave: int = 4):
func play_note(midi: int):
	# Call one of the sampler to play the note
	var sampler: Sampler = samplers[next_available]
	sampler.play_note(midi)
	next_available = (next_available + 1) % max_notes

func stop_all():
	for s in samplers:
		var sampler: Sampler = s
		sampler.stop()

func stop_note(midi: int):
	for s in samplers:
		var sampler: Sampler = s
		if (sampler.get_midi() == midi):
			sampler.stop()

# Stop the note with a release
func release_all():
	for s in samplers:
		var sampler: Sampler = s
		sampler.release()

func release_note(midi: int):
	for s in samplers:
		var sampler: Sampler = s
		if (sampler.get_midi() == midi):
			sampler.release()
