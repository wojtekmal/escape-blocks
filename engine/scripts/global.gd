extends Node

var current_level : String = "1"
 
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
	
	print(preload("res://levels/test_level_template.tscn").instantiate())

var levels := {}

var saved_var := {
	"levels" : levels,
	"current_level" : current_level,
}

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
	for variable in saved_var.keys():
		saved_var[variable] = content[variable]

func save():
	saved_var = {
		"levels" : levels,
		"current_level" : current_level,
	}
	
	print(levels)
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
		"resource": preload("res://levels/test_level_template.tscn"),
		"unlocks": ["2a", "2b"],
		"dependencies": [],
	},
	"2a": {
		"resource": preload("res://levels/level_2.tscn"),
		"unlocks": ["3"],
		"dependencies": ["1"],
	},
	"2b": {
		"resource": preload("res://levels/level_2_v2.tscn"),
		"unlocks": [],
		"dependencies": ["1"],
	},
	"3": {
		"resource": preload("res://levels/wojtekmal_1.tscn"),
		"unlocks": ["4"],
		"dependencies": ["2a"],
	},
	"4": {
		"resource": preload("res://levels/test_level_template_2.tscn"),
		"unlocks": ["5"],
		"dependencies": ["3"],
	},
	"5": {
		"resource": preload("res://levels/roupiq_1.tscn"),
		"unlocks": [],
		"dependencies": ["4"],
	},
}
