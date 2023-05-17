@tool
extends MarginContainer

signal pressed

@export_multiline var label_text : String = "" : set = set_label_text
#@export var action : String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.pressed.connect(emit_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	label_text = new_value
	$Label.text = new_value

func emit_pressed():
	emit_signal("pressed")
