@tool
class_name LevelButton
extends Node2D

signal button_pressed

@onready var pressable_button := $TextureButton
#var is_unlocked : bool = false
	
# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $TextureButton/Label
	#print(label_text)
	
	label.text = name
	set_label_text(name)
	pressable_button.pressed.connect(on_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	#print("check")
	var label = $TextureButton/Label
	if(global.levels.has(name)):
		label.text = new_value
	else:
		label.text = "NULL"
		name = "NULL"
	#print(label.text)

func on_button_pressed():
	emit_signal("button_pressed", name)

func _on_renamed():
	set_label_text(name)
