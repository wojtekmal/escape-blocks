extends Node2D

@onready var pause_screen := $Control/CanvasLayer

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
	print(new_level)
	print(level_name)
	print(global.levels_data["2a"]["resource"].instantiate())
	# This can be removed when all levels get their final name.
	new_level.level_name = level_name
	new_level.retry_this_level.connect(start)
	new_level.change_to_next_level.connect(change_to_next_level)
	add_child(new_level)
	await new_level.ready

func _ready():
	current_level = global.current_level
	start(current_level)

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pause(not paused)
	
	if Input.is_action_just_pressed("restart"):
		start(current_level)

func change_to_next_level(level_name: String):
	if global.levels_data[level_name]["unlocks"].is_empty():
		get_tree().change_scene_to_file("res://map_stuff/level_map.tscn")
		return
	
	var level = global.levels_data[level_name]["unlocks"][0]
	start(level)

func pause(value := true):
	paused = value
	for level in get_tree().get_nodes_in_group("level"):
		#get_child(0).get_child(0).get_child(6).get_child(2).stop(true)
		get_tree().paused = value
		
		
	pause_screen.visible = paused
