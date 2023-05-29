@tool
extends Node2D

var buttons := {}
var ZOOM_SPEED = PI * 1.5
var ZOOM_MIN = 0.1
var ZOOM_MAX = 7.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(preload("res://levels/level_2.tscn").instantiate())
	if !Engine.is_editor_hint():
		$MapHUD.visible = true
	
	for button_reference in get_tree().get_nodes_in_group("level_buttons"):
		button_reference.button_pressed.connect(on_level_button_pressed)
		button_reference.refresh_map.connect(refresh_map)
		buttons[button_reference.name] = button_reference
	
	$Tutorial.button_pressed.connect(on_level_button_pressed)
	
	var back_to_menu_button := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/MarginContainer2/TextureButton
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var part_count_label := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/PartsBox/HBoxContainer/Label
	part_count_label.text = str(global.part_count)
	
	var map_camera := $MapCamera
	
	for button_text in buttons:
		if button_text == global.current_level:
			map_camera.position = buttons[button_text].position
	
	#print("check")
	
	init_graph()

func init_graph():
	#print("check")
	for button_text in buttons:
		#print(button_text)
		if not global.levels_data.has(button_text):
			#print("is_null")
			button_text = "NULL"
		
		for dependency in global.levels_data[button_text]["unlocks"]:
			if !buttons.has(dependency):
				continue
			
			var line = Line2D.new()
			line.add_point(buttons[button_text].position)
			line.add_point(buttons[dependency].position)
			line.default_color = Color8(128, 128, 128)
			line.z_index = -1
			
			if (global.levels.has(button_text) && global.levels[button_text]["unlocked"] ||
			global.levels.has(dependency) && global.levels[dependency]["unlocked"]):
				line.default_color = Color8(0, 0, 0)
			
			add_child(line)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_level_button_pressed(level_name):
	#print("Level map detected tutorial button.")
	global.current_level = level_name
	get_tree().change_scene_to_file("res://levels/level_restart.tscn")

func go_to_menu():
	get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")

func refresh_map():
	var part_count_label := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/PartsBox/HBoxContainer/Label
	part_count_label.text = str(global.part_count)
	
	global.save()

func _input(event : InputEvent, delta = get_physics_process_delta_time()) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			var map_camera = $MapCamera
			match event.button_index:
				MOUSE_BUTTON_WHEEL_DOWN:
					map_camera.zoom_factor -= ZOOM_SPEED * delta * map_camera.zoom_factor
				MOUSE_BUTTON_WHEEL_UP:
					map_camera.zoom_factor += ZOOM_SPEED * delta * map_camera.zoom_factor
			
			map_camera.zoom_factor = min(ZOOM_MAX, map_camera.zoom_factor)
			map_camera.zoom_factor = max(ZOOM_MIN, map_camera.zoom_factor)
			map_camera.zoom = Vector2(map_camera.zoom_factor, map_camera.zoom_factor)
	elif event is InputEventKey:
		print("Map detected key press.")
