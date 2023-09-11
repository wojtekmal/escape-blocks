@tool
extends Control

@export var mode : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var tab_container := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer
	var back_to_menu_button := $MyPanel/MarginContainer/VBoxContainer/ExternalButtonsBox/HBoxContainer/MyButton
	var reset_progress := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Gameplay/VBoxContainer/ResetProgress
	var switch_rotation := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Input/VBoxContainer/SwitchRotation
	var volume := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Audio/VBoxContainer/Volume
	var music_volume := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Audio/VBoxContainer/MusicVolume
	var sound_effects_volume := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer/Audio/VBoxContainer/SoundEffectsVolume
	
	back_to_menu_button.pressed.connect(go_to_menu)
	tab_container.get_child(0).get_child(0).get_child(0).grab_focus()
	
	reset_progress.pressed.connect(reset_progress_press)
	switch_rotation.toggled.connect(call_switch_rotation)
	switch_rotation.button_pressed = global.settings["switch_rotation"]
	volume.value_changed.connect(change_volume)
	volume.value = global.settings["change_volume"]
	music_volume.value_changed.connect(change_music_volume)
	music_volume.value = global.settings["change_music_volume"]
	sound_effects_volume.value_changed.connect(change_sound_effects_volume)
	sound_effects_volume.value = global.settings["change_sound_effects_volume"]

# Called every frame. 'delta' is the elapsed time since the previous frame.                                                                                              
func _process(delta):
	if !is_visible_in_tree():
		return
	
	var tab_container := $MyPanel/MarginContainer/VBoxContainer/ScrollPanelBox/TabContainer
	
	if Input.is_action_just_pressed("ui_focus_prev"):# || Input.is_action_just_pressed("ui_left"):
		tab_container.current_tab = (tab_container.get_tab_count() + tab_container.current_tab - 1) % tab_container.get_tab_count()
		tab_container.get_child(tab_container.current_tab).get_child(0).get_child(0).grab_focus()
	elif Input.is_action_just_pressed("ui_focus_next"):# || Input.is_action_just_pressed("ui_right"):
		tab_container.current_tab = (tab_container.current_tab + 1) % tab_container.get_tab_count()
		tab_container.get_child(tab_container.current_tab).get_child(0).get_child(0).grab_focus()
	
	var theme = preload("res://themes/main_theme.tres")
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
	
	tab_container.add_theme_stylebox_override("tab_selected", stylebox)
	tab_container.add_theme_stylebox_override("tab_unselected", stylebox)
	tab_container.add_theme_stylebox_override("tab_hovered", stylebox)
	
	if Input.is_action_just_pressed("back"):
		go_to_menu()

func go_to_menu():
	if mode == "in_level":
		visible = false
	else:
		get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")

func call_switch_rotation(new_value):
	global.settings["switch_rotation"] = new_value
	print(global.settings["switch_rotation"])
	global.save()

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
	global.levels = {}
	
	global.current_level = "1"
	global.part_count = 0
	global.save()
