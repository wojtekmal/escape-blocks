extends Node2D

var buttons := {}
var ZOOM_SPEED = PI * 1.5
var ZOOM_MIN = 0.1
var ZOOM_MAX = 7.0
@onready var level_button = preload("res://map_stuff/level_button.tscn")
var last_pos := 0
@onready var map_camera := $MapCamera

var slide_texts := [
	"After months of voyage, the famous \"Złomek\" was nearing its destination.",
	"You, the ships mechanic, were playing poker with your crewmates.",
	"Suddenly, \"Złomek\" got hit by a rouge group of meteroites.",
	"Everyone except for you got sucked out through a hole in the ships walls.",
	"It is now your job to fix the ship as quickly as possible.",
]

# Called when the node enters the scene tree for the first time.
func _ready():
	if !Engine.is_editor_hint():
		$MapHUD.visible = true
	
	manage_phone_rotation()
	get_viewport().gui_focus_changed.connect(move_camera_to_button)
	
	for button_reference in get_tree().get_nodes_in_group("level_buttons"):
		button_reference.level_button_pressed.connect(on_level_button_pressed)
		button_reference.refresh_map.connect(refresh_map)
		buttons[button_reference.real_name] = button_reference
	
	$Tutorial.level_button_pressed.connect(on_level_button_pressed)
	$Random.level_button_pressed.connect(on_level_button_pressed)
	$MEGA_RANDOM.level_button_pressed.connect(on_level_button_pressed)
	
	if OS.get_name() == "Web" || global.is_mobile():
		$MEGA_RANDOM.visible = false
	
	var back_to_menu_button := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/MyButton
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var part_count_label := $MapHUD/MarginContainer/VBoxContainer/HBoxContainer/PartsBox/HBoxContainer/Label
	part_count_label.text = str(global.part_count)
	
	for button_text in buttons:
		if button_text == global.current_level:
			map_camera.position = buttons[button_text].position
	
	init_graph()
	
	if !has_node(global.current_level):
		global.current_level = "1"
	
	if (global.current_level == "MEGA RANDOM"):
		$MEGA_RANDOM.grab_focus()
	else:
		get_node(global.current_level).grab_focus()
	
	map_camera.zoom.x = global.zoom_factor
	map_camera.zoom.y = global.zoom_factor
	
	if global.show_cutscene:
		global.show_cutscene = false
		on_level_button_pressed("Tutorial")

func _process(delta):
	if Engine.is_editor_hint():
		return
	
	if Input.is_action_just_pressed("back"):
		go_to_menu()
	
	zoom_camera(delta)
	manage_phone_rotation()

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
	line3.add_point($Tutorial.position + tutorial_line_offset)
	line3.add_point($Random.position + tutorial_line_offset)
	line3.default_color = Color8(256, 256, 256)
	line3.z_index = -1
	add_child(line3)
	
	if OS.get_name() != "Web" && !global.is_mobile():
		var line4 = Line2D.new()
		line4.add_point($Random.position + tutorial_line_offset)
		line4.add_point($MEGA_RANDOM.position + tutorial_line_offset)
		line4.default_color = Color8(256, 256, 256)
		line4.z_index = -1
		add_child(line4)
	
	for button_text in buttons:
		if not global.levels_data.has(button_text):
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
	global.current_level = level_name
	get_tree().call_deferred("change_scene_to_file", "res://levels/level_restart.tscn")

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
	map_camera.position = button_reference.position + button_reference.size / 2

func manage_phone_rotation():
	if !global.is_mobile():
		return
	
	global.control_manage_phone_rotation($MapHUD/MarginContainer)
	map_camera.rotation = global.phone_rotation * PI / 2

func zoom_camera(delta):
	var map_camera = $MapCamera
	map_camera.zoom.x = lerp(map_camera.zoom.x, global.zoom_factor, delta * 10)
	map_camera.zoom.y = lerp(map_camera.zoom.y, global.zoom_factor, delta * 10)
	map_camera.zoom_factor = global.zoom_factor
