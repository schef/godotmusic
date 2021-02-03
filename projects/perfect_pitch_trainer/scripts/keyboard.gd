extends Node

var pitchList = []
var textbox

func find_node_by_name(root, name):
	if(root.get_name() == name): return root
	for child in root.get_children():
		if(child.get_name() == name):
			return child
		var found = find_node_by_name(child, name)
		if(found): return found
	return null

func get_key_node(name: String):
	return find_node_by_name(get_tree().get_root(), name)

func update_text():
	var text = PoolStringArray(pitchList).join(", ")
	textbox.text = text

func _ready():
	textbox = get_key_node("TEXTBOX")
	textbox.connect("pressed", self, "on_textbox_pressed")
	var key_c = get_key_node("KEY_C")
	key_c.connect("pressed", self, "on_key_pressed", ["c"])
	
func on_key_pressed(pitch: String):
	pitchList.append(pitch)
	update_text()

func on_textbox_pressed():
	pitchList.clear()
	update_text()
