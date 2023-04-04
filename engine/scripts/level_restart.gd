extends Node2D

var levels := {
	"1" : preload("res://levels/test_level_template.tscn")
}
@export var actual_level := "1"

func start(level_name : String):
	for level in get_tree().get_nodes_in_group("level"):
		level.queue_free()
		level.hide()
		await level.tree_exited
	var new_level = levels[level_name].instantiate()
	add_child(new_level)
	await new_level.ready

func _ready():
	start(actual_level)

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		start(actual_level)
