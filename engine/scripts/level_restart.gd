extends Node2D

@onready var pause_screen := $Control/CanvasLayer

# "level name" : preload("res://path/to/level")
var levels := {
	"1" : preload("res://levels/test_level_template.tscn"),
	"hourglass" : preload("res://levels/level_2.tscn"),
	"hourglass2" : preload("res://levels/level_2_v2.tscn"),
	"3" : preload("res://levels/wojtekmal_1.tscn"),
	"4" : preload("res://levels/test_level_template_2.tscn"),
	"training_1" : preload("res://levels/roupiq_1.tscn"),
}

var paused = false
@export var current_level : String

func start(level_name : String):
	pause(false)
	for level in get_tree().get_nodes_in_group("level"):
		level.queue_free()
		level.hide()
		await level.tree_exited
	var new_level = levels[level_name].instantiate()
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

func pause(value := true):
	paused = value
	for level in get_tree().get_nodes_in_group("level"):
		get_tree().paused = value
	pause_screen.visible = paused
