@tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export_multiline var buttonText := "" : set = UpdateLabel # (String, MULTILINE)
@export var custom_method : String
@onready var label := $CenterContainer/ButtonLabel
@onready var pressable_button = $AspectRatioContainer/TextureButton


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = buttonText
	pressable_button.pressed.connect(on_button_press)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func UpdateLabel(newName):
	var label = $CenterContainer/ButtonLabel
	if Engine.is_editor_hint():
		label.text = newName
	buttonText = newName

func on_button_press():
	if !has_method(custom_method):
		print("The method this button calls doesn't exist.")
		return
	
	call(custom_method)

func new_game_press():
	# This is a dictionary holding the default values for global.levels.
	# When "New game" is pressed, levels is set to this. If "Continue game is chosen, 
	# the saved version of levels is chosen (TODO).
	
	for level_name in global.levels_data:
		global.levels[level_name] = {
			"unlocked": false,
			"finished_parts": 0,
			"rotation_parts": 0,
			"time_parts": 0,
		}
	
	global.levels["1"]["unlocked"] = true
	
	get_tree().change_scene_to_file("res://map_stuff/level_map.tscn")
