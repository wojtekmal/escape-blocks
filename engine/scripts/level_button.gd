@tool
class_name LevelButton
extends Node2D

@export_multiline var label_text : String : set = set_label_text
@export var dependencies : Array[String] = []

var is_unlocked : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $TextureButton/Label
	#print(label_text)
	
	if Engine.is_editor_hint():
		label.text = label_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	#print("check")
	if Engine.is_editor_hint():
		var label = $TextureButton/Label
		label.text = new_value
		#print(label.text)
		label_text = new_value
