@tool
extends Node2D

var buttons := {}
var ZOOM_SPEED = PI * 1.5
var ZOOM_MIN = 0.1
var ZOOM_MAX = 7.0
@onready var level_button = preload("res://map_stuff/level_button.tscn")
var last_pos := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(preload("res://levels/level_2.tscn").instantiate())
	if !Engine.is_editor_hint():
		$MapHUD.visible = true
	load_all()
	
	for button_reference in get_tree().get_nodes_in_group("level_buttons"):
		button_reference.button_pressed.connect(on_level_button_pressed)
		button_reference.refresh_map.connect(refresh_map)
		buttons[button_reference.real_name] = button_reference
	
	$Tutorial.button_pressed.connect(on_level_button_pressed)
	
	var back_to_menu_button := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/MyButton
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var part_count_label := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/PartsBox/HBoxContainer/Label
	part_count_label.text = str(global.part_count)
	
	var map_camera := $MapCamera
	
	for button_text in buttons:
		if button_text == global.current_level:
			map_camera.position = buttons[button_text].position
	
	#print("check")
	init_graph()

func load_all():
	var path = "res://levels/"
	add_levels(path, "")

func add_levels(path, dirname):
	var rows = 6
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				add_levels(path + file_name + "/", dirname + file_name + "/")
			else:
				global.levels_data[dirname + file_name] = {"resource":load(path + file_name), "unlocks": [], "part_price": 0,}
				global.levels[dirname + file_name] = {
					"unlocked": 2,
					"finished_parts": 0,
					"rotation_parts": 0,
					"time_parts": 0,
				}
#				global.levels[dirname + file_name]["unlocked"] = true
#				print(dirname + file_name, " ",  global.levels_data[dirname + file_name])
				
				var new_button = level_button.instantiate()
				new_button.position = Vector2i(last_pos % rows * 300, last_pos / rows * 78) + Vector2i.UP * 700
				if (last_pos/rows) % 2 == 0: 
					new_button.position.x += 150
				new_button.on_level_bought()
				last_pos += 1
				
				new_button.name = dirname + "/" + file_name
				new_button.set_label_text(dirname + file_name)
				
				add_child(new_button)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	$Panel.position = Vector2i.UP * 700 - Vector2i(150, 100)
	$Panel.size = Vector2(rows * 300 + 150, ((last_pos + rows -1 )/ rows) * 78 + 100)
	
func init_graph():
	#print("check")
	for button_text in buttons:
		#print(button_text)
		if not global.levels_data.has(button_text):
			#print("is_null")
			print("nonexistent level: " + button_text)
			button_text = "NULL"
			continue
		
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

func on_level_button_pressed(level_name):
	#print("Level map detected tutorial button.")
	print(level_name)
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
