extends Node

var current_level : String = "1"
var part_count : int = 0
 
# This is a dictionary holding all levels by their numbers.
# Here all important information about levels is held in this format:
#
#"level_number": {
# 	"unlocked": bool,
#	"finished_parts": int, # This is 0 or 1 depending on whether the level was finished.
#	"rotation_parts": int, # This is 0, 1, or 2.
#	"time_parts": int, # This is 0, 1 or 2.
#}

func _ready():
	name = "global"
	load_data()
	
	#print(preload("res://levels/test_level_template.tscn").instantiate())

var levels := {}

# Moved to save().
#var saved_var := {
#	"levels" : levels,
#	"current_level" : current_level,
#	"settings" : settings,
#}

func load_data():
	var file = FileAccess.open(
		"user://" + name +".dat", 
		FileAccess.READ
	)
	
	if file == null:
		print("Saved game not found, creating new game.")
		save()
		return
	var content = file.get_var()
	print(content)
	
	if content.has("levels"):
		levels = content["levels"]
	if content.has("current_level"):
		current_level = content["current_level"]
	if content.has("settings"):
		settings = content["settings"]
	if content.has("part_count"):
		part_count = content["part_count"]
	
	manage_settings()

func save():
	var saved_var = {
		"levels" : levels,
		"current_level" : current_level,
		"settings" : settings,
		"part_count" : part_count,
	}
	
	print(saved_var)
	#print(saved_var)
	var file = FileAccess.open(
		"user://" + name + ".dat", 
		FileAccess.WRITE,
	)
	file.store_var(saved_var)
	#print(content)
	print("saved " + name)

# This dictionary also contains all levels' scenes and dependencies.
var levels_data := {
	"1": {
		"resource": load("res://levels/test_level_template.tscn"),
		"unlocks": ["2a", "2b"],
		"dependencies": [],
	},
	"2a": {
		"resource": load("res://levels/level_2.tscn"),
		"unlocks": ["3"],
		"dependencies": ["1"],
	},
	"2b": {
		"resource": load("res://levels/level_2_v2.tscn"),
		"unlocks": [],
		"dependencies": ["1"],
	},
	"3": {
		"resource": load("res://levels/wojtekmal_1.tscn"),
		"unlocks": ["4"],
		"dependencies": ["2a"],
	},
	"4": {
		"resource": load("res://levels/test_level_template_2.tscn"),
		"unlocks": ["5"],
		"dependencies": ["3"],
	},
	"5": {
		"resource": load("res://levels/roupiq_1.tscn"),
		"unlocks": [],
		"dependencies": ["4"],
	},
	"6": {
		"resource": load("res://levels/frutlevel1.tscn"),
		"unlocks": [],
		"dependencies": ["5"],
	},
	"NULL": {
		"resource": load("res://levels/NULL.tscn"),
		"unlocks": [],
		"dependencies": [],
	},
}

var settings := {
	"switch_rotation": false,
}

func manage_settings():
	switch_rotation(settings["switch_rotation"])

func switch_rotation(new_value: bool):
	#if settings["switch_rotation_direction"] == new_value:
	#	return
	
	settings["switch_rotation"] = new_value
	save()
	InputMap.action_erase_events("gravity_left")
	InputMap.action_erase_events("gravity_right")
	
	if new_value == false:
		var key = InputEventKey.new()
		key.physical_keycode = KEY_LEFT
		InputMap.action_add_event("gravity_left", key)
		var key2 = InputEventKey.new()
		key2.physical_keycode = KEY_RIGHT
		InputMap.action_add_event("gravity_right", key2)
	else:
		var key = InputEventKey.new()
		key.physical_keycode = KEY_RIGHT
		InputMap.action_add_event("gravity_left", key)
		var key2 = InputEventKey.new()
		key2.physical_keycode = KEY_LEFT
		InputMap.action_add_event("gravity_right", key2)
