@tool
extends MarginContainer

signal changed

@export_multiline var label_text : String = "" : set = set_label_text
@export var action : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var button = $HBoxContainer/MarginContainer/TextureButton
	button.pressed.connect(button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	label_text = new_value
	var label = $HBoxContainer/MarginContainer/MarginContainer/Label
	label.text = new_value

func button_pressed():
	emit_signal("changed", action, null)

