extends Node

var pitchList = []
var textbox
var init = false

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

func register_key(label: String, pitch: String):
	var key_c = get_key_node(label)
	key_c.connect("pressed", self, "on_key_pressed", [pitch])

func _ready():
	register_key("KEY_C", "c")
	register_key("KEY_CIS", "cis")
	register_key("KEY_D", "d")
	register_key("KEY_ES", "es")
	register_key("KEY_E", "e")
	register_key("KEY_F", "f")
	register_key("KEY_FIS", "fis")
	register_key("KEY_G", "g")
	register_key("KEY_AS", "as")
	register_key("KEY_A", "a")
	register_key("KEY_B", "b")
	register_key("KEY_H", "h")
	textbox = get_key_node("TEXTBOX")
	textbox.connect("pressed", self, "on_textbox_pressed")

func update_text():
	var text = PoolStringArray(pitchList).join(", ")
	textbox.text = text

func on_key_pressed(pitch: String):
	pitchList.append(pitch)
	update_text()

func on_textbox_pressed():
	pitchList.pop_back()
	update_text()

func init():
	if (!init):
		init = true
		var min_size = textbox.get_custom_minimum_size()
		min_size.x = get_key_node("KEY_D").get_position()[0] + get_key_node("KEY_C").get_size()[0] - get_key_node("KEY_C").get_position()[0]
		textbox.set_custom_minimum_size(min_size)
		
func _process(delta):
	init()
