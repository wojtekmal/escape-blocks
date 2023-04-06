extends Node2D

# "level name" : preload("res://path/to/level")
var levels := {
	"1" : preload("res://levels/test_level_template.tscn"),
	"hourglass" : preload("res://levels/level_2.tscn"),
	"hourglass2" : preload("res://levels/level_2_v2.tscn"),
	"3" : preload("res://levels/wojtekmal_1.tscn"),
	"4" : preload("res://levels/test_level_template_2.tscn"),
}

@export var current_level := "hourglass"

func start(level_name : String):
	for level in get_tree().get_nodes_in_group("level"):
		level.queue_free()
		level.hide()
		await level.tree_exited
	var new_level = levels[level_name].instantiate()
	add_child(new_level)
	await new_level.ready

func _ready():
	start(current_level)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		start(current_level)
