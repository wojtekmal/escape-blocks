@tool
extends Node

var current_level : String = "1"
var part_count : int = 0
var zoom_factor : float = 0.7
var current_random_level : int = 0

#@onready var ui_click_player = AudioStreamPlayer.new()
 
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
#	print(content)
	
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
	if content.has("current_random_level"):
		current_random_level = content["current_random_level"]
	
	manage_settings()

func save():
	var saved_var = {
		"levels" : levels,
		"current_level" : current_level,
		"settings" : settings,
		"part_count" : part_count,
		"zoom_factor" : zoom_factor,
		"current_random_level" : current_random_level,
	}
	
#	print(saved_var)
	#print(saved_var)
	var file = FileAccess.open(
		"user://" + name + ".dat", 
		FileAccess.WRITE,
	)
	file.store_var(saved_var)
	#print(content)
#	print("saved " + name)

# This dictionary also contains all levels' scenes and dependencies.
var levels_data := {
	"Tutorial": {
		"resource": load("res://levels/tutorial/1.tscn"),
		"unlocks": ["tutorial_rotating"],
		"part_price": 0,
	},
	"tutorial_rotating": {
		"resource": load("res://levels/tutorial/2.tscn"),
		"unlocks": ["final_tutorial"],
		"part_price": 0,
	},
	"final_tutorial": {
		"resource": load("res://levels/tutorial/3.tscn"),
		"unlocks": [],
		"part_price": 0,
	},
	"NULL": {
		"resource": load("res://levels/LevelTemplate.tscn"),
		"unlocks": [],
		"part_price": 0,
	},
	"Random": {
		"resource": load("res://levels/random_level.tscn"),
		"unlocks": [],
		"part_price": 0,
	},
	"MEGA RANDOM": {
		"resource": load("res://levels/z_other/MEGA_RANDOM.tscn"),
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
	
	#switch_rotation(settings["switch_rotation"])

#func switch_rotation(new_value: bool):
#	#if settings["switch_rotation_direction"] == new_value:
#	#	return
#
#	settings["switch_rotation"] = new_value
#	save()
##	print(settings["switch_rotation"])
##	var left_key = InputMap.action_get_events("gravity_left")[0]
##	var right_key = InputMap.action_get_events("gravity_right")[0]
##	InputMap.action_erase_events("gravity_left")
##	InputMap.action_erase_events("gravity_right")
##	InputMap.action_add_event("gravity_left", right_key)
##	InputMap.action_add_event("gravity_right", left_key)
#
#	InputMap.action_erase_events("gravity_left")
#	InputMap.action_erase_events("gravity_right")
#
#	if new_value == false:
#		var key = InputEventKey.new()
#		key.physical_keycode = KEY_LEFT
#		InputMap.action_add_event("gravity_left", key)
#		var key2 = InputEventKey.new()
#		key2.physical_keycode = KEY_RIGHT
#		InputMap.action_add_event("gravity_right", key2)
#	else:
#		var key = InputEventKey.new()
#		key.physical_keycode = KEY_RIGHT
#		InputMap.action_add_event("gravity_left", key)
#		var key2 = InputEventKey.new()
#		key2.physical_keycode = KEY_LEFT
#		InputMap.action_add_event("gravity_right", key2)

#func play_ui_click():
#	print(ui_click_player.stream)
#	ui_click_player.play()
