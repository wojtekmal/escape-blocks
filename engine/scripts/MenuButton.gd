@tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
@export_multiline var buttonText := "" : set = UpdateLabel # (String, MULTILINE)
@export var path_to_scene : String
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
	if !ResourceLoader.exists(path_to_scene):
		print("The scene this button leads to doesn't exist.")
		return
	print("check")
	get_tree().change_scene_to_file(path_to_scene)
