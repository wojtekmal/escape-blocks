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

var levels := {}

# This dictionary also contains all levels' scenes and dependencies.
var levels_data := {
	"1": {
		"resource": preload("res://levels/test_level_template.tscn"),
		"dependencies": [],
	},
	"2a": {
		"resource": preload("res://levels/level_2.tscn"),
		"dependencies": [],
	},
	"2b": {
		"resource": preload("res://levels/level_2_v2.tscn"),
		"dependencies": [],
	},
	"3": {
		"resource": preload("res://levels/wojtekmal_1.tscn"),
		"dependencies": [],
	},
	"4": {
		"resource": preload("res://levels/test_level_template_2.tscn"),
		"dependencies": [],
	},
	"5": {
		"resource": preload("res://levels/roupiq_1.tscn"),
		"dependencies": [],
	},
}
