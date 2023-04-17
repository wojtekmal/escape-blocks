@tool
extends Node2D

var buttons := {}

# Called when the node enters the scene tree for the first time.
func _ready():
	print(preload("res://levels/level_2.tscn").instantiate())
	for button_reference in get_tree().get_nodes_in_group("level_buttons"):
		button_reference.button_pressed.connect(on_level_button_pressed)
		buttons[button_reference.name] = button_reference
		#print(button_reference.label_text)
	
	#if global.levels == {}:
	#	# This is a dictionary holding the default values for global.levels.
	#	# When "New game" is pressed, levels is set to this. If "Continue game is chosen, 
	#	# the saved version of levels is chosen (TODO).
	#
	#	global.levels = {
	#		"1": {
#				"unlocked": true,
#				"finished_parts": 0,
#				"rotation_parts": 0,
#				"time_parts": 0,
#			},
#			"2": {
#				"unlocked": false,
#				"finished_parts": 0,
#				"rotation_parts": 0,
#				"time_parts": 0,
#			},
#			"3": {
#				"unlocked": false,
#				"finished_parts": 0,
#				"rotation_parts": 0,
#				"time_parts": 0,
#			},
#		}
	
	init_graph()

func init_graph():
	for button_text in buttons:
		if not global.levels_data.has(button_text):
			button_text = "NULL"
		for dependency in global.levels_data[button_text]["dependencies"]:
			if global.levels[dependency]["finished_parts"] == 1:
				global.levels[button_text]["unlocked"] = true
		
		if global.levels[button_text]["unlocked"]:
			buttons[button_text].pressable_button.disabled = false
	
	for button_text in buttons:
		if not global.levels_data.has(button_text):
			button_text = "NULL"
		for dependency in global.levels_data[button_text]["dependencies"]:
			
			var line = Line2D.new()
			line.add_point(buttons[button_text].position)
			line.add_point(buttons[dependency].position)
			line.default_color = Color8(0, 0, 0)
			line.z_index = -1
			add_child(line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_level_button_pressed(level_name):
	global.current_level = level_name
	get_tree().change_scene_to_file("res://levels/level_restart.tscn")
