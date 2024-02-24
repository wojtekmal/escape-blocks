@tool
extends Node

var current_level : String = "1"
var part_count : int = 0
var zoom_factor : float = 0.7
var current_random_level : int = 0
var show_cutscene : bool = false
var phone_rotation : int = 0
var newer_phone_rotation : int = 0

@onready var phone_rotation_timer = Timer.new()

var ZOOM_SPEED = PI * 1.5
var ZOOM_MIN = 0.1
var ZOOM_MAX = 7.0
 
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
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_name.call_deferred("global")
	load_data()
	
	phone_rotation_timer.wait_time = 0.5
	phone_rotation_timer.one_shot = true
	add_child(phone_rotation_timer)

var levels := {}

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	manage_phone_rotation()
	zoom_camera(delta)

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
	
	var file = FileAccess.open(
		"user://" + name + ".dat", 
		FileAccess.WRITE,
	)
	file.store_var(saved_var)

# This dictionary also contains all levels' scenes and dependencies.
var levels_data := {
	"1": {
		"resource": load("res://levels/4QT0R/1.tscn"),
		"unlocks": ["2"],
		"part_price": 0,
	},
	"2": {
		"resource": load("res://levels/Herbercik/level_0_1.tscn"),
		"unlocks": ["3", "2a", "2b"],
		"part_price": 0,
	},
	"2a": {
		"resource": load("res://levels/roupiq/2.tscn"),
		"unlocks": ["3a"],
		"part_price": 0,
	},
	"2b": {
		"resource": load("res://levels/4QT0R/3.tscn"),
		"unlocks": ["3b"],
		"part_price": 0,
	},
	"3": {
		"resource": load("res://levels/wojtekmal/1.tscn"),
		"unlocks": ["4", "3a", "3b"],
		"part_price": 0,
	},
	"3a": {
		"resource": load("res://levels/wojtekmal/2.tscn"),
		"unlocks": ["3", "2a"],
		"part_price": 0,
	},
	"3b": {
		"resource": load("res://levels/4QT0R/2.tscn"),
		"unlocks": ["3", "2b"],
		"part_price": 0,
	},
	"4": {
		"resource": load("res://levels/roupiq/1.tscn"),
		"unlocks": ["5"],
		"part_price": 0,
	},
	"5": {
		"resource": load("res://levels/tutorial/4.tscn"),
		"unlocks": ["6", "5a", "5b"],
		"part_price": 0,
	},
	"5a": {
		"resource": load("res://levels/Herbercik/level_1_3.tscn"),
		"unlocks": ["6a", "5"],
		"part_price": 0,
	},
	"5b": {
		"resource": load("res://levels/Herbercik/level_1_1.tscn"),
		"unlocks": ["6b", "5"],
		"part_price": 0,
	},
	"6": {
		"resource": load("res://levels/tutorial/5.tscn"),
		"unlocks": ["7", "6a", "6b"],
		"part_price": 0,
	},
	"6a": {
		"resource": load("res://levels/Herbercik/level_1_5.tscn"),
		"unlocks": ["6", "5a"],
		"part_price": 0,
	},
	"6b": {
		"resource": load("res://levels/wojtekmal/4.tscn"),
		"unlocks": ["6", "5b"],
		"part_price": 0,
	},
	"7": {
		"resource": load("res://levels/frutman/frutlevel1.tscn"),
		"unlocks": ["8"],
		"part_price": 0,
	},
	"8": {
		"resource": load("res://levels/frutman/frutlevel2.tscn"),
		"unlocks": ["9"],
		"part_price": 0,
	},
	"9": {
		"resource": load("res://levels/frutman/frutlevel3.tscn"),
		"unlocks": ["10"],
		"part_price": 0,
	},
	"10": {
		"resource": load("res://levels/roupiq/aaa.tscn"),
		"unlocks": ["11", "10a", "10b"],
		"part_price": 0,
	},
	"10a": {
		"resource": load("res://levels/roupiq/aaaa.tscn"),
		"unlocks": ["11a"],
		"part_price": 0,
	},
	"10b": {
		"resource": load("res://levels/Herbercik/level_1_6.tscn"),
		"unlocks": ["11b"],
		"part_price": 0,
	},
	"11": {
		"resource": load("res://levels/Herbercik/level_1_4.tscn"),
		"unlocks": ["12"],
		"part_price": 0,
	},
	"11a": {
		"resource": load("res://levels/z_other/level_2_v2.tscn"),
		"unlocks": ["12a", "10a"],
		"part_price": 0,
	},
	"11b": {
		"resource": load("res://levels/Herbercik/level_1_7.tscn"),
		"unlocks": ["12b", "10b"],
		"part_price": 0,
	},
	"12": {
		"resource": load("res://levels/roupiq/bird.tscn"),
		"unlocks": ["12a", "12b", "11"],
		"part_price": 0,
	},
	"12a": {
		"resource": load("res://levels/wojtekmal/6.tscn"),
		"unlocks": ["12", "11a"],
		"part_price": 0,
	},
	"12b": {
		"resource": load("res://levels/wojtekmal/5.tscn"),
		"unlocks": ["12", "11b"],
		"part_price": 0,
	},
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
		"unlocks": ["Random"],
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
	"change_volume": 0,
	"change_sound_effects_volume": 0,
	"change_music_volume": 0,
	"show_hint": true
}

func manage_settings():
	var master_bus = AudioServer.get_bus_index("Master")
	var music_bus = AudioServer.get_bus_index("Music")
	var sound_effects_bus = AudioServer.get_bus_index("Sound Effects")
	
	if settings.has("change_volume"):
		AudioServer.set_bus_volume_db(master_bus, (settings["change_volume"] - 100) * 72 / 100)
	if settings.has("change_sound_effects_volume"):
		AudioServer.set_bus_volume_db(master_bus, (settings["change_sound_effects_volume"] - 100) * 72 / 100)
	if settings.has("change_music_volume"):
		AudioServer.set_bus_volume_db(master_bus, (settings["change_music_volume"] - 100) * 72 / 100)
	
	if !settings.has("show_hint"):
		settings["show_hint"] = true


func manage_phone_rotation():
	if !is_mobile():
		return
	
	var gravity : Vector3 = Sensors.get_accelerometer().snapped(Vector3(0.001,0.001,0.001))
	var newest_phone_rotation : int
	# 0 - bottom down, 1 - right down, 2 - top down, 3 - left down
	
	if abs(gravity.y) > abs(gravity.x) && gravity.y < 0:
		newest_phone_rotation = 0
	elif abs(gravity.y) > abs(gravity.x) && gravity.y >= 0:
		newest_phone_rotation = 2
	elif abs(gravity.y) <= abs(gravity.x) && gravity.x >= 0:
		newest_phone_rotation = 1
	elif abs(gravity.y) <= abs(gravity.x) && gravity.x < 0:
		newest_phone_rotation = 3
	
	if newest_phone_rotation != newer_phone_rotation:
		newer_phone_rotation = newest_phone_rotation
		phone_rotation_timer.start()
	
	if newer_phone_rotation != phone_rotation && phone_rotation_timer.time_left == 0:
		phone_rotation = newer_phone_rotation

func reset_phone_rotation():
	newer_phone_rotation = 0
	phone_rotation = 0

func control_manage_phone_rotation(control: Control):
	var viewport_size = get_viewport().get_visible_rect().size
	
	if global.phone_rotation == 0:
		control.pivot_offset = Vector2(0,0)
		control.rotation = 0
		control.size = Vector2(viewport_size.x, viewport_size.y)
	elif global.phone_rotation == 1:
		control.pivot_offset = Vector2(viewport_size.y / 2, viewport_size.y / 2)
		control.rotation = 3 * PI / 2
		control.size = Vector2(viewport_size.y, viewport_size.x)
	elif global.phone_rotation == 2:
		control.pivot_offset = Vector2(viewport_size.x / 2, viewport_size.y / 2)
		control.rotation = PI
		control.size = Vector2(viewport_size.x, viewport_size.y)
	elif global.phone_rotation == 3:
		control.pivot_offset = Vector2(viewport_size.x / 2, viewport_size.x / 2)
		control.rotation = PI / 2
		control.size = Vector2(viewport_size.y, viewport_size.x)


func zoom_camera(delta):
	global.zoom_factor *= 1 + Input.get_action_strength("zoom_in") * delta * ZOOM_SPEED
	global.zoom_factor *= 1 - Input.get_action_strength("zoom_out") * delta * ZOOM_SPEED
	global.zoom_factor = clamp(global.zoom_factor, ZOOM_MIN, ZOOM_MAX)

func is_mobile():
	return OS.has_feature("android") || OS.has_feature("ios") || \
			OS.has_feature("web_android") || OS.has_feature("web_ios")
