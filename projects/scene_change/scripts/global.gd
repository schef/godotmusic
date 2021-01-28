extends Node

var masterclasses
var group_index = null
var practice_index = null

func _ready():
	var file = File.new()
	file.open("res://masterclasses.json", file.READ)
	var json = file.get_as_text()
	masterclasses = JSON.parse(json).result
	file.close()
	pass # Replace with function body.

func get_title():
	return masterclasses["title"]

func get_subtitle():
	return masterclasses["subtitle"]
	
func get_version():
	return masterclasses["version"]

func get_masterclasses():
	return masterclasses["masterclasses"]

func get_masterclass(group_index: int):
	return masterclasses["masterclasses"][group_index]

func get_practice(group_index: int, practice_index: int):
	return masterclasses["masterclasses"][group_index]["practices"][practice_index]

func get_group_index():
	return group_index

func set_group_index(index: int):
	group_index = index
	
func reset_group_index():
	group_index = null
	
func set_practice_index(index: int):
	practice_index = index
	
func get_practice_index():
	return practice_index

func reset_practice_index():
	practice_index = null
