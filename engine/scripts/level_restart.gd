extends Node2D

# "level name" : preload("res://path/to/level")
var levels := {
	"1" : preload("res://levels/test_level_template.tscn"),
	"hourglass" : preload("res://levels/level_2.tscn"),
	"hourglass2" : preload("res://levels/level_2_v2.tscn"),
	"3" : preload("res://levels/wojtekmal_1.tscn"),
	"4" : preload("res://levels/test_level_template_2.tscn"),
	"training_1" : preload("res://levels/roupiq_1.tscn"),
}

@export var current_level := "training_1"

func start(level_name : String):
	for level in get_tree().get_nodes_in_group("level"):
		level.queue_free()
		level.hide()
		await level.tree_exited
	var new_level = levels[level_name].instantiate()
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
	if Input.is_action_just_pressed("restart"):
		start(current_level)

func change_to_next_level(level_name: String):
	var level_name_found : bool = false
	
	for level in levels.keys():
		if level_name_found:
			start(level)
			return
		
		if level == level_name:
			level_name_found = true
	
	get_tree().change_scene_to_file("res://map_stuff/level_map.tscn")
