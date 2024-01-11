extends Node2D

var buttons := {}
var ZOOM_SPEED = PI * 1.5
var ZOOM_MIN = 0.1
var ZOOM_MAX = 7.0
@onready var level_button = preload("res://map_stuff/level_button.tscn")
var last_pos := 0
var current_slide := 0
@onready var map_camera := $MapCamera
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
	#load_all()
	
	get_viewport().gui_focus_changed.connect(move_camera_to_button)
	
	for button_reference in get_tree().get_nodes_in_group("level_buttons"):
		button_reference.level_button_pressed.connect(on_level_button_pressed)
		button_reference.refresh_map.connect(refresh_map)
		buttons[button_reference.real_name] = button_reference
	
	$Tutorial.level_button_pressed.connect(on_level_button_pressed)
	$Random.level_button_pressed.connect(on_level_button_pressed)
	$MEGA_RANDOM.level_button_pressed.connect(on_level_button_pressed)
	
	var back_to_menu_button := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/MyButton
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var part_count_label := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/PartsBox/HBoxContainer/Label
	part_count_label.text = str(global.part_count)
	
	for button_text in buttons:
		if button_text == global.current_level:
			map_camera.position = buttons[button_text].position
	
	#print("check")
	init_graph()
	
	switch_slide(0)
	$CanvasLayer/ColorRect/VBoxContainer/MarginContainer2/HBoxContainer/Next.pressed.connect(next_slide)
	$CanvasLayer/ColorRect/VBoxContainer/MarginContainer2/HBoxContainer/Skip.pressed.connect(skip_slides)
	
	if !has_node(global.current_level):
		global.current_level = "1"
	
	if (global.current_level == "MEGA RANDOM"):
		$MEGA_RANDOM.grab_focus()
	else:
		get_node(global.current_level).grab_focus()
	
	map_camera.zoom.x = global.zoom_factor
	map_camera.zoom.y = global.zoom_factor
	
	if global.show_cutscene:
		#$CanvasLayer.visible = true
		global.show_cutscene = false
		skip_slides()
		#$CanvasLayer/ColorRect/VBoxContainer/MarginContainer2/HBoxContainer/Next.grab_focus()

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	#get_tree().quit()
	
	if Input.is_action_just_pressed("back"):
		go_to_menu()
	
	#manage_phone_rotation()
	#global.control_manage_phone_rotation($MapHUD/MarginContainer)
	#global.control_manage_phone_rotation($CanvasLayer/ColorRect)
	zoom_camera(delta)

func switch_slide(slide_num):
	if slide_num >= slide_texts.size():
		$CanvasLayer.visible = false
		on_level_button_pressed("Tutorial")
		return
	
	current_slide = slide_num
	var slide_label = $CanvasLayer/ColorRect/VBoxContainer/MarginContainer3/Label
	slide_label.text = slide_texts[current_slide]
	animation_player.play(animation_key_list[current_slide])

func next_slide():
	switch_slide(current_slide + 1)

func skip_slides():
#	$CanvasLayer.visible = false
	switch_slide(slide_texts.size())

func load_all():
	var path = "res://levels/"
	add_levels(path, "")

func add_levels(path, dirname):
	$Panel.visible = true
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
					#"time_parts": 0,
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
	var line_offset = Vector2(32, 32)
	var tutorial_line_offset = Vector2(64,64)
	
	var line2 = Line2D.new()
	line2.add_point($Tutorial.position + tutorial_line_offset)
	line2.add_point(buttons["1"].position + line_offset)
	line2.default_color = Color8(256, 256, 256)
	line2.z_index = -1
	add_child(line2)
	var line3 = Line2D.new()
	line2.add_point($Tutorial.position + tutorial_line_offset)
	line2.add_point($Random.position + tutorial_line_offset)
	line2.default_color = Color8(256, 256, 256)
	line2.z_index = -1
	add_child(line2)
	var line4 = Line2D.new()
	line2.add_point($Random.position + tutorial_line_offset)
	line2.add_point($MEGA_RANDOM.position + tutorial_line_offset)
	line2.default_color = Color8(256, 256, 256)
	line2.z_index = -1
	add_child(line2)
	
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
			line.add_point(buttons[button_text].position + line_offset)
			line.add_point(buttons[dependency].position + line_offset)
			line.default_color = Color8(128, 128, 128)
			line.z_index = -1
			
			if (global.levels.has(button_text) && global.levels[button_text]["unlocked"] ||
			global.levels.has(dependency) && global.levels[dependency]["unlocked"]):
				line.default_color = Color8(256, 256, 256)
			
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
					global.zoom_factor -= ZOOM_SPEED * delta * global.zoom_factor
				MOUSE_BUTTON_WHEEL_UP:
					global.zoom_factor += ZOOM_SPEED * delta * global.zoom_factor
			
			map_camera.zoom_factor = min(ZOOM_MAX, map_camera.zoom_factor)
			map_camera.zoom_factor = max(ZOOM_MIN, map_camera.zoom_factor)
			map_camera.zoom = Vector2(map_camera.zoom_factor, map_camera.zoom_factor)
			var zoom_change = map_camera.zoom_factor / current_zoom
			map_camera.position = lerp(mouse_pos, map_camera.position, 1 / zoom_change)

func move_camera_to_button(button_reference):
	map_camera.position = button_reference.position

func manage_phone_rotation():
	if OS.get_name() != "Android":
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	
	if global.phone_rotation == 0:
		rotation = 0
	elif global.phone_rotation == 1:
		rotation = 3 * PI / 2
	elif global.phone_rotation == 2:
		rotation = PI
	elif global.phone_rotation == 3:
		rotation = PI / 2

func zoom_camera(delta):
	var map_camera = $MapCamera
	map_camera.zoom.x = lerp(map_camera.zoom.x, global.zoom_factor, delta * 10)
	map_camera.zoom.y = lerp(map_camera.zoom.y, global.zoom_factor, delta * 10)
	map_camera.zoom_factor = global.zoom_factor
