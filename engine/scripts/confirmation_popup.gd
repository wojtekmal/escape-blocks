@tool
extends CanvasLayer

signal ok_pressed
signal cancel_pressed

@export_multiline var label_text : String = "" : set = set_label_text

# Called when the node enters the scene tree for the first time.
func _ready():
	var ok_button := $MarginContainer/MyPanel/VBoxContainer/ButtonsBox/HBoxContainer/OkBox/MyButton
	var cancel_button := $MarginContainer/MyPanel/VBoxContainer/ButtonsBox/HBoxContainer/CancelBox/MyButton
	
	ok_button.pressed.connect(on_ok_pressed)
	cancel_button.pressed.connect(on_cancel_pressed)
	$IgnoreButton.button_down.connect(queue_free)
	ok_button.grab_focus()
	#get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		queue_free()

func set_label_text(new_value):
	label_text = new_value
	var label = $MarginContainer/MyPanel/VBoxContainer/Label
	label.text = new_value

func on_ok_pressed():
	get_tree().paused = false
	emit_signal("ok_pressed")
	queue_free()

func on_cancel_pressed():
	get_tree().paused = false
	emit_signal("cancel_pressed")
	queue_free()
