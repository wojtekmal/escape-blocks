@tool
extends Node2D

var buttons := {}
var ZOOM_SPEED = PI * 1.5
var ZOOM_MIN = 0.1
var ZOOM_MAX = 7.0
@onready var level_button = preload("res://map_stuff/level_button.tscn")
var last_pos := 0
var current_slide := 0
@onready var animation_player := $CanvasLayer/ColorRect/VBoxContainer/MarginContainer/TextureRect/AnimationPlayer
@onready var animation_key_list = animation_player.get_animation_list()

var slide_texts := [
	"After months of voyage, the famous \"Złomek\" was nearing its destination.",
	"You, the ships mechanic, were playing poker with your crewmates.",
	"Suddenly, \"Złomek\" got hit by a rouge group of meteroites.",
	"Everyone except for you got sucked out through a hole in the ships walls.",
	"It is now your job to fix the ship as quickly as possible.",
]

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
	$Random.button_pressed.connect(on_level_button_pressed)
	$MEGA_RANDOM.button_pressed.connect(on_level_button_pressed)
	
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
	
	if global.show_cutscene:
		$CanvasLayer.visible = true
		global.show_cutscene = false
	
	switch_slide(0)
	$CanvasLayer/ColorRect/VBoxContainer/MarginContainer2/HBoxContainer/Next.pressed.connect(next_slide)
	$CanvasLayer/ColorRect/VBoxContainer/MarginContainer2/HBoxContainer/Skip.pressed.connect(skip_slides)

func switch_slide(slide_num):
	if slide_num >= slide_texts.size():
		$CanvasLayer.visible = false
		return
	
	current_slide = slide_num
	var slide_label = $CanvasLayer/ColorRect/VBoxContainer/MarginContainer3/Label
	slide_label.text = slide_texts[current_slide]
	animation_player.play(animation_key_list[current_slide])

func next_slide():
	switch_slide(current_slide + 1)

func skip_slides():
	$CanvasLayer.visible = false

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
				if file_name != "maps":
					add_levels(path + file_name + "/", dirname + file_name + "/")
			else:
				file_name = file_name.replace(".remap" , "")
				file_name = file_name.replace(".tscn" , "")
				
				global.levels_data[dirname + file_name] = {"resource":load(path + file_name + ".tscn"), "unlocks": [], "part_price": 0,}
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
			var mouse_pos = get_global_mouse_position()
			var current_zoom = map_camera.zoom_factor
			match event.button_index:
				MOUSE_BUTTON_WHEEL_DOWN:
					map_camera.zoom_factor -= ZOOM_SPEED * delta * map_camera.zoom_factor
				MOUSE_BUTTON_WHEEL_UP:
					map_camera.zoom_factor += ZOOM_SPEED * delta * map_camera.zoom_factor
			
			map_camera.zoom_factor = min(ZOOM_MAX, map_camera.zoom_factor)
			map_camera.zoom_factor = max(ZOOM_MIN, map_camera.zoom_factor)
			map_camera.zoom = Vector2(map_camera.zoom_factor, map_camera.zoom_factor)
			var zoom_change = map_camera.zoom_factor / current_zoom
			map_camera.position = lerp(mouse_pos, map_camera.position, 1 / zoom_change)

#func _input(event):
#	if event is InputEventMouse:
#		if event.is_pressed() and not event.is_echo():
#			var mouse_position = event.position
#			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
#				zoom_at_point(ZOOM_SPEED,mouse_position)
#			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#				zoom_at_point(1/ZOOM_SPEED,mouse_position)

#func zoom_at_point(zoom_change, point):
#	var map_camera := $MapCamera
#	var c0 = global_position # camera position
#	var v0 = get_viewport().size # vieport size
#	var c1 # next camera position
#	var z0 = map_camera.zoom.x # current zoom value
#	var z1 = z0 * zoom_change # next zoom value
#
#	c1 = c0 + (-0.5*v0 + point)*(z0 - z1)
#
#	z1 = max(ZOOM_MIN, z1)
#	z1 = min(ZOOM_MAX, z1)
#	map_camera.zoom = Vector2(z1, z1)
#	global_position = c1
