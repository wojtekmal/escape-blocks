tool
extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(String, MULTILINE) var buttonText := "" setget UpdateLabel
onready var label := $CenterContainer/ButtonLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	label.text = buttonText
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func UpdateLabel(newName):
	label = $CenterContainer/ButtonLabel
	if Engine.editor_hint:
		label.set_text(newName)
	buttonText = newName
