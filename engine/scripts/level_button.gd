@tool
class_name LevelButton
extends Node2D

signal button_pressed

@export var label_text : String : set = set_label_text
#@export var dependencies : Array[String] = []

@onready var pressable_button := $TextureButton
#var is_unlocked : bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $TextureButton/Label
	#print(label_text)
	
	label.text = label_text
	pressable_button.pressed.connect(on_button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	#print("check")
	var label = $TextureButton/Label
	label.text = new_value
	#print(label.text)
	label_text = new_value

func on_button_pressed():
	emit_signal("button_pressed", label_text)
