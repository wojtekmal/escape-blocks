@tool
extends Control

@export var mode : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var back_to_menu_button := $MyPanel/MarginContainer/VBoxContainer/ExternalButtonsBox/HBoxContainer/MyButton
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var settings_list = $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Gameplay/VBoxContainer.get_children()
	settings_list.append_array($MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Audio/VBoxContainer.get_children())
	settings_list.append_array($MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Input/VBoxContainer.get_children())
	
	for setting in settings_list:
		if !setting.has_signal("changed"):
			continue
		
		setting.changed.connect(manage_changing_settings)
		
		if "disabled_in_level" in setting && mode == "in_level":
			setting.disabled = true
	
	#print(preload("res://themes/main_theme.tres").get_stylebox_type_list())

# Called every frame. 'delta' is the elapsed time since the previous frame.                                                                                              
func _process(delta):
	var theme = preload("res://themes/main_theme.tres")
	var tab_container := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer
	var tab_count = tab_container.get_child_count()
	#print(tab_count)
	var total_len = 0
	var font = preload("res://fonts/conthrax/conthrax-sb.otf")
	var font_size = theme.get_font_size("font_size", "TabContainer")
	#print(preload("res://themes/main_theme.tres").has_stylebox("tab_selected", "normal"))
	var stylebox = theme.get_stylebox("tab_selected", "TabContainer")
	var side_margin = theme.get_constant("side_margin", "TabContainer")
	var tabbar_len = tab_container.size.x - side_margin
	
	#print(stylebox.border_width_left)
	
	for i in tab_count:
		var title = tab_container.get_tab_title(i)
		total_len += font.get_string_size(title, 0, -1, font_size).x
	
	stylebox.set_content_margin(SIDE_LEFT, (tabbar_len - total_len) * 1.0 / tab_count / 2)
	stylebox.set_content_margin(SIDE_RIGHT, (tabbar_len - total_len) * 1.0 / tab_count / 2)
	
	#print((total_len - tabbar_len) * 1.0 / tab_count / 2)
	#print(tabbar_len)
	#print(stylebox.border_width_left)
	
	tab_container.add_theme_stylebox_override("tab_selected", stylebox)
	tab_container.add_theme_stylebox_override("tab_unselected", stylebox)
	tab_container.add_theme_stylebox_override("tab_hovered", stylebox)

func go_to_menu():
	if mode == "in_level":
		visible = false
	else:
		get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")

func manage_changing_settings(action, new_value):
	if action == "switch_rotation":
		#print("Settings received switch rotation.")
		global.settings["switch_rotation"] = new_value
		global.save()
	elif action == "reset_progress":
		reset_progress_press()
	elif action == "change_volume":
		change_volume(new_value)
	elif action == "change_sound_effects_volume":
		change_sound_effects_volume(new_value)
	elif action == "change_music_volume":
		change_music_volume(new_value)
	else:
		print("This setting's method doesn't exist in settings.gd. ~wojtekmal")

func change_sound_effects_volume(new_value):
	global.settings["change_sound_effects_volume"] = new_value
	global.save()
	var sound_effects_bus = AudioServer.get_bus_index("Sound Effects")
	AudioServer.set_bus_volume_db(sound_effects_bus, (new_value - 100) * 72 / 100)

func change_music_volume(new_value):
	global.settings["change_music_volume"] = new_value
	global.save()
	var music_bus = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(music_bus, (new_value - 100) * 72 / 100)

func change_volume(new_value):
	global.settings["change_volume"] = new_value
	global.save()
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, (new_value - 100) * 72 / 100)

func reset_progress_press():
	#print("check")
	var confirmation_popup = preload("res://menu_stuff/confirmation_popup.tscn").instantiate()
	confirmation_popup.ok_pressed.connect(reset_progress)
	get_tree().get_root().add_child(confirmation_popup)

func reset_progress():
#	for level_name in global.levels_data:
#		global.levels[level_name] = {
#			"unlocked": 0,
#			"finished_parts": 0,
#			"rotation_parts": 0,
##			"time_parts": 0,
#		}
	
	global.levels = {}
	
#	global.levels["1"]["unlocked"] = 2
	global.current_level = "1"
	global.part_count = 0
	global.save()
