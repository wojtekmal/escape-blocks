@tool
extends Node2D

var buttons = {
	"1": {
		"dependencies": [],
		"reference": 0 # Placeholder.
	},
	"2": {
		"dependencies": ["1"],
		"reference": 0
	},
	"3": {
		"dependencies": ["2"],
		"reference": 0
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	for button_reference in get_tree().get_nodes_in_group("level_buttons"):
		button_reference.button_pressed.connect(on_level_button_pressed)
		buttons[button_reference.label_text]["reference"] = button_reference
		#print(button_reference.label_text)
	
	if global.levels == {}:
		# This is a dictionary holding the default values for global.levels.
		# When "New game" is pressed, levels is set to this. If "Continue game is chosen, 
		# the saved version of levels is chosen (TODO).

		global.levels = {
			"1": {
				"unlocked": true,
				"finished_parts": 0,
				"rotation_parts": 0,
			"time_parts": 0,
			},
			"2": {
				"unlocked": false,
				"finished_parts": 0,
				"rotation_parts": 0,
				"time_parts": 0,
			},
			"3": {
				"unlocked": false,
				"finished_parts": 0,
				"rotation_parts": 0,
				"time_parts": 0,
			},
		}
	
	init_graph()

func init_graph():
	for button_text in buttons:
		for dependency in buttons[button_text]["dependencies"]:
			if global.levels[dependency]["finished_parts"] == 1:
				global.levels[button_text]["unlocked"] = true
		
		if global.levels[button_text]["unlocked"]:
			buttons[button_text]["reference"].pressable_button.disabled = false
	
	for button_text in buttons:
		for dependency in buttons[button_text]["dependencies"]:
			
			var line = Line2D.new()
			line.add_point(buttons[button_text]["reference"].position)
			line.add_point(buttons[dependency]["reference"].position)
			line.default_color = Color8(0, 0, 0)
			line.z_index = -1
			add_child(line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_level_button_pressed(level_name):
	global.current_level = level_name
	get_tree().change_scene_to_file("res://levels/level_restart.tscn")
