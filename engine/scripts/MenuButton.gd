extends TextureButton

@export_multiline var buttonText := "" : set = UpdateLabel
@export var custom_method : String
@onready var label := $ButtonLabel
var level_map := preload("res://map_stuff/level_map.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = buttonText
	pressed.connect(on_button_press)

func _process(delta):
	if has_focus():
		$Panel.visible = true
	else:
		$Panel.visible = false

func UpdateLabel(newName):
	var label = $ButtonLabel
	if Engine.is_editor_hint():
		label.text = newName
	buttonText = newName

func on_button_press():
	if !has_method(custom_method):
		print("The method this button calls doesn't exist.")
		return
	
	call(custom_method)

func load_new_game():
	# This is a dictionary holding the default values for global.levels.
	# When "New game" is pressed, levels is set to this. If "Continue game is chosen, 
	# the saved version of levels is chosen (TODO).
	
	for level_name in global.levels_data:
		global.levels[level_name] = {
			"unlocked": 0,
			"finished_parts": 0,
			"rotation_parts": 0,
#			"time_parts": 0,
		}
	
	global.levels["1"]["unlocked"] = 2
	global.current_level = "1"
	global.save()
	global.show_cutscene = true
	
	get_tree().change_scene_to_packed(level_map)

func continue_game_press():
	if global.levels == {}:
		load_new_game()
		print("global.levels == {}")
		return
	
	get_tree().change_scene_to_packed(level_map)

func settings_press():
	get_tree().change_scene_to_file("res://menu_stuff/settings.tscn")

func exit_game_press():
	get_tree().quit()

func about_press():
	get_tree().change_scene_to_file("res://menu_stuff/about.tscn")
