@tool
extends Node2D

var buttons = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for button_reference in get_tree().get_nodes_in_group("level_buttons"):
		buttons[button_reference.label_text] = button_reference
		button_reference.button_pressed.connect(on_level_button_pressed)
		#print(button_reference.label_text)
	
	set_graph()

func set_graph():
	for button_text in buttons:
		for dependency in buttons[button_text].dependencies:
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
