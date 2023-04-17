extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var back_to_menu_button := $VBoxContainer/ExternalButtonsBox/HBoxContainer/BackToMenuBox/BackToMenu
	back_to_menu_button.pressed.connect(go_to_menu)
	
	var settings_list := $VBoxContainer/ScrollPanelBox/ScrollContainer/VBoxContainer
	
	for setting in settings_list.get_children():
		setting.changed.connect(manage_changing_settings)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func go_to_menu():
	get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")

func manage_changing_settings(action, new_value):
	if action == "switch_rotation":
		global.switch_rotation(new_value)
	elif action == "reset_progress":
		reset_progress_press()
	else:
		print("This setting's method doesn't exist in settings.gd. ~wojtekmal")


func reset_progress_press():
	print("check")
	var confirmation_popup = preload("res://menu_stuff/confirmation_popup.tscn").instantiate()
	confirmation_popup.ok_pressed.connect(reset_progress)
	get_tree().get_root().add_child(confirmation_popup)

func reset_progress():
	for level_name in global.levels_data:
		global.levels[level_name] = {
			"unlocked": false,
			"finished_parts": 0,
			"rotation_parts": 0,
			"time_parts": 0,
		}
	
	global.levels["1"]["unlocked"] = true
	global.current_level = "1"
	global.save()
