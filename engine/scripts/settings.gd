@tool
extends Control

@export var mode : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var back_to_menu_button := $VBoxContainer/ExternalButtonsBox/HBoxContainer/BackToMenuBox/BackToMenu
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var settings_list = $VBoxContainer/ScrollPanelBox/TabContainer/Misc/VBoxContainer.get_children()
	settings_list.append_array($VBoxContainer/ScrollPanelBox/TabContainer/Audio/VBoxContainer.get_children())
	settings_list.append_array($VBoxContainer/ScrollPanelBox/TabContainer/Input/VBoxContainer.get_children())
	
	for setting in settings_list:
		if !setting.has_signal("changed"):
			continue
		
		setting.changed.connect(manage_changing_settings)
		
		if "disabled_in_level" in setting && mode == "in_level":
			setting.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func go_to_menu():
	if mode == "in_level":
		visible = false
	else:
		get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")

func manage_changing_settings(action, new_value):
	if action == "switch_rotation":
		#print("Settings received switch rotation.")
		global.switch_rotation(new_value)
	elif action == "reset_progress":
		reset_progress_press()
	elif action == "change_volume":
		change_volume(new_value)
	else:
		print("This setting's method doesn't exist in settings.gd. ~wojtekmal")

func change_volume(new_value):
	global.settings["change_volume"] = new_value
	global.save()
	var master_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(master_bus, (new_value - 100) * 72 / 100)

func reset_progress_press():
	print("check")
	var confirmation_popup = preload("res://menu_stuff/confirmation_popup.tscn").instantiate()
	confirmation_popup.ok_pressed.connect(reset_progress)
	get_tree().get_root().add_child(confirmation_popup)

func reset_progress():
	for level_name in global.levels_data:
		global.levels[level_name] = {
			"unlocked": 0,
			"finished_parts": 0,
			"rotation_parts": 0,
			"time_parts": 0,
		}
	
	global.levels["1"]["unlocked"] = 2
	global.current_level = "1"
	global.part_count = 0
	global.save()
