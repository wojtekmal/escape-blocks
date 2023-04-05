@tool
extends Node2D

var buttons

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = get_tree().get_nodes_in_group("level_buttons")
	
	for button in buttons:
		for dependency in dependencies

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
