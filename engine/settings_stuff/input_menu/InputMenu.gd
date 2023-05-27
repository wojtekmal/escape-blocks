extends Control

@onready var _action_list = get_node("Column/ScrollContainer/ActionList")

func _ready():
	$InputMapper.profile_changed.connect(rebuild)
	$Column/ProfilesMenu.initialize($InputMapper)
	$InputMapper.change_profile($Column/ProfilesMenu.selected)

func rebuild(input_profile, is_customizable=false):
	_action_list.clear()
	for input_action in input_profile.keys():
		var line = _action_list.add_input_line(input_action, \
			input_profile[input_action], is_customizable)
		if is_customizable:
			line.change_button_pressed.connect(_on_InputLine_change_button_pressed.bind([input_action, line]))

func _on_InputLine_change_button_pressed(flags):
	var action_name = flags[0]
	var line = flags[1]
	set_process_input(false)
	
	$KeySelectMenu.open()
	var key_scancode = await $KeySelectMenu.key_selected
	$InputMapper.change_action_key(action_name, key_scancode)
	line.update_key(key_scancode)
	
	set_process_input(true)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		get_tree().change_scene("res://demo/Game.tscn")

func _on_PlayButton_pressed():
	get_tree().change_scene("res://demo/Game.tscn")
