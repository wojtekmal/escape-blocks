@tool
extends Node

var current_level : String = "1"
var part_count : int = 0
var zoom_factor : float = 0.7
 
# This is a dictionary holding all levels by their numbers.
# Here all important information about levels is held in this format:
#
#"level_number": {
# 	"unlocked": int,
#	"finished_parts": int, # This is 0 or 1 depending on whether the level was finished.
#	"rotation_parts": int, # This is 0, 1, or 2.
#	"time_parts": int, # This is 0, 1 or 2.
#}

func _ready():
	if Engine.is_editor_hint():
		return
	
	name = "global"
	load_data()

var levels := {}

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
	if content.has("zoom_factor") && content["zoom_factor"] != 0:
		zoom_factor = content["zoom_factor"]
	
	manage_settings()

func save():
	var saved_var = {
		"levels" : levels,
		"current_level" : current_level,
		"settings" : settings,
		"part_count" : part_count,
		"zoom_factor" : zoom_factor,
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
		"resource": load("res://levels/tutorial.tscn"),
		"unlocks": ["2a", "2b"],
		"part_price": 0,
	},
	"2a": {
		"resource": load("res://levels/level_2.tscn"),
		"unlocks": ["3"],
		"part_price": 5,
	},
	"2b": {
		"resource": load("res://levels/level_2_v2.tscn"),
		"unlocks": [],
		"part_price": 0,
	},
	"3": {
		"resource": load("res://levels/wojtekmal_1.tscn"),
		"unlocks": ["4"],
		"part_price": 0,
	},
	"4": {
		"resource": load("res://levels/test_level_template_2.tscn"),
		"unlocks": ["5"],
		"part_price": 3,
	},
	"5": {
		"resource": load("res://levels/roupiq_1.tscn"),
		"unlocks": ["6"],
		"part_price": 2,
	},
	"6": {
		"resource": load("res://levels/frutlevel1.tscn"),
		"unlocks": ["7"],
		"part_price": 0,
	},
	"7": {
		"resource": load("res://levels/4QT0R_1.tscn"),
		"unlocks": ["8"],
		"part_price": 0,
	},
	"8": {
		"resource": load("res://levels/4QT0R_2.tscn"),
		"unlocks": ["9"],
		"part_price": 0,
	},
	"9": {
		"resource": load("res://levels/4QT0R_3.tscn"),
		"unlocks": ["10"],
		"part_price": 0,
	},
	"10": {
		"resource": load("res://levels/Herberik_level_1_4.tscn"),
		"unlocks": [],
		"part_price": 0,
	},
	"11": {
		"resource": load("res://levels/test_level_template.tscn"),
		"unlocks": [],
		"part_price": 0,
	},
	"NULL": {
		"resource": load("res://levels/NULL.tscn"),
		"unlocks": [],
		"part_price": 0,
	},
}

var settings := {
	"switch_rotation": false,
	"change_volume": 0
}

func manage_settings():
	var master_bus = AudioServer.get_bus_index("Master")
	if settings.has("change_volume"):
		AudioServer.set_bus_volume_db(master_bus, (settings["change_volume"] - 100) * 72 / 100)
	
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
