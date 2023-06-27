extends Node2D

@onready var pause_screen := $CanvasLayer

var paused = false
@export var current_level : String

func next_file(path = "res://levels/maps"):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		if file_name != "":
			return "end"
		if dir.current_is_dir():
			next_file(path + file_name + "/")
		else:
			file_name = file_name.replace(".remap" , "")
			return file_name
		file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	return "error"

func start(level_name : String):
	pause(false)
	current_level = level_name
	for level in get_tree().get_nodes_in_group("level"):
		level.queue_free()
		level.hide()
		await level.tree_exited
	var new_level = global.levels_data[level_name]["resource"].instantiate()
	
	if level_name == "Random":
		var dir := DirAccess.open("res://levels/maps/")
		var levels := dir.get_files()
		
		var file = FileAccess.open("res://levels/maps/" + levels[global.current_random_level], FileAccess.READ)
		new_level.walls_source = file.get_as_text()

		get_window().title = "random level: " + str(global.current_random_level) + " - " + levels[global.current_random_level]
		
		global.current_random_level += 1
		global.current_random_level %= levels.size()
		global.save()
	else:
		get_window().title = level_name

	# This can be removed when all levels get their final name.
	new_level.level_name = level_name
	new_level.retry_this_level.connect(start)
	new_level.change_to_next_level.connect(change_to_next_level)
	add_child(new_level)
	await new_level.ready

func _ready():
	var resume := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Resume
	var restart := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Restart
	var settings := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Settings
	var map := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Map
	resume.pressed.connect(unpause)
	restart.pressed.connect(start_current_level)
	settings.pressed.connect(open_settings)
	map.pressed.connect(go_to_map)
	current_level = global.current_level
	start(current_level)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause(not paused)
	
	if Input.is_action_just_pressed("restart"):
		start(current_level)

func go_to_map():
	unpause()
	get_tree().change_scene_to_file("res://map_stuff/level_map.tscn")

func open_settings():
	$SettingsLayer/Settings.visible = true

func start_current_level():
	start(global.current_level)

func change_to_next_level(level_name: String):
	if global.levels_data[level_name]["unlocks"].is_empty():
		get_tree().change_scene_to_file("res://map_stuff/level_map.tscn")
		return
	
	var level = global.levels_data[level_name]["unlocks"][0]
	start(level)

func unpause():
	pause(false)

func pause(value := true):
	paused = value
	get_tree().paused = value
	pause_screen.visible = paused
