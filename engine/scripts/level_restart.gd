extends Node2D

@onready var pause_screen := $CanvasLayer

var paused = false
@export var current_level : String

func start(level_name : String):
	pause(false)
	current_level = level_name
	for level in get_tree().get_nodes_in_group("level"):
		level.queue_free()
		level.hide()
		await level.tree_exited
	var new_level = global.levels_data[level_name]["resource"].instantiate()
	
	if level_name == "Random":
		print(DirAccess.open("res://levels/maps"))
		var dir := DirAccess.open("res://levels/maps/")
		var levels := dir.get_files()
		
		var file = FileAccess.open("res://levels/maps/" + levels[global.current_random_level], FileAccess.READ)
		new_level.walls_source = file.get_as_text()

		get_window().title = "random level: " + str(global.current_random_level) + " - " + levels[global.current_random_level]
		
		global.current_random_level += 1
		global.current_random_level %= levels.size()
		global.save()
	elif level_name == "MEGA RANDOM":
		randomize()
		var seed = str(randi() % 1000)
		var size = str(randi() % 3 + 5)
		
		var output = []
		var exit_code = OS.execute("board_generator/MEGA_RANDOM.exe", [size, seed], output, false, true)
		if exit_code != 0:
			print("error while generating level: ", exit_code)
		print(output[0])
		
		new_level.walls_source = output[0]

		get_window().title = "MEGA RANDOM: " + size + " " + seed
	else:
		get_window().title = level_name

	# This can be removed when all levels get their final name.
	new_level.level_name = level_name
	new_level.retry_this_level.connect(restart_current_level)
	new_level.change_to_next_level.connect(change_to_next_level)
	new_level.pause.connect(pause)
	add_child(new_level)
	await new_level.ready

func _ready():
	var resume := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Resume
	var restart := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Restart
	var settings := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Settings
	var map := $CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Map
	resume.pressed.connect(unpause)
	restart.pressed.connect(restart_current_level)
	settings.pressed.connect(open_settings)
	map.pressed.connect(go_to_map)
	current_level = global.current_level
	start(current_level)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause(not paused)
	
	if Input.is_action_just_pressed("restart"):
		restart_current_level()

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
	$CanvasLayer/Control/VBoxContainer/MarginContainer/HBoxContainer/Resume.grab_focus()

func restart_current_level(level_name = current_level):
	if current_level == "Random":
		global.current_random_level -= 1
	
	start(current_level)
	
