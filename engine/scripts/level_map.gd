@tool
extends Node2D

var buttons

# Called when the node enters the scene tree for the first time.
func _ready():
	buttons = get_tree().get_nodes_in_group("level_buttons")
	
	for button in buttons:
		for dependency in button.dependencies:
			for button in buttons:
				if 
			var line = Line2D.new()
			line.add_point()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
