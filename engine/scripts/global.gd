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
		save()
		return
	var content = file.get_var()
	for variable in saved_var.keys():
		saved_var[variable] = content[variable]

func save(content = saved_var):
	var file = FileAccess.open(
		"user://" + name + ".dat", 
		FileAccess.WRITE,
	)
	file.store_var(content)
	print("saved " + name)
