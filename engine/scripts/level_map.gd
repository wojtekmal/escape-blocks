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
	
	var back_to_menu_button := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/TextureButton
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var part_count_label := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/PartsBox/HBoxContainer/Label
	part_count_label.text = str(global.part_count)
	
	var map_camera := $MapCamera
	
	for button_text in buttons:
		if button_text == global.current_level:
			map_camera.position = buttons[button_text].position
	
	init_graph()

func init_graph():
	for button_text in buttons:
		if global.levels.has(button_text) && global.levels[button_text]["unlocked"]:
			buttons[button_text].pressable_button.disabled = false
		
		if not global.levels_data.has(button_text):
			button_text = "NULL"
		
		for dependency in global.levels_data[button_text]["unlocks"]:
			var line = Line2D.new()
			line.add_point(buttons[button_text].position)
			line.add_point(buttons[dependency].position)
			line.default_color = Color8(0, 0, 0)
			line.z_index = -1
			
			if !global.levels[button_text]["unlocked"] || !global.levels[dependency]["unlocked"]:
				line.default_color = Color8(128, 128, 128)
			
			add_child(line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_level_button_pressed(level_name):
	global.current_level = level_name
	get_tree().change_scene_to_file("res://levels/level_restart.tscn")

func go_to_menu():
	get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")

