@tool
extends MarginContainer

signal ok_pressed
signal cancel_pressed

@export_multiline var label_text : String = "" : set = set_label_text

# Called when the node enters the scene tree for the first time.
func _ready():
	var ok_button := $VBoxContainer/ButtonsBox/HBoxContainer/OkBox/TextureButton
	var cancel_button := $VBoxContainer/ButtonsBox/HBoxContainer/CancelBox/TextureButton
	
	ok_button.pressed.connect(on_ok_pressed)
	cancel_button.pressed.connect(on_cancel_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	label_text = new_value
	var label = $VBoxContainer/Label
	label.text = new_value

func on_ok_pressed():
	emit_signal("ok_pressed")
	queue_free()

func on_cancel_pressed():
	emit_signal("cancel_pressed")
	queue_free()
