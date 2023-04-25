extends MarginContainer

signal ok_pressed
signal cancel_pressed

var left_click_previous_frame : bool = false
var button_pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var ok_button := $VBoxContainer/HBoxContainer/OkBox/TextureButton
	var cancel_button := $VBoxContainer/HBoxContainer/CancelBox/TextureButton
	
	ok_button.button_down.connect(on_ok_pressed)
	cancel_button.pressed.connect(on_cancel_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if left_click_previous_frame:
		queue_free()
	
	if Input.is_action_just_pressed("left_click"):
		left_click_previous_frame = true
		return

func on_ok_pressed():
	print("ok_pressed")
	if !button_pressed:
		emit_signal("ok_pressed")
		button_pressed = true

func on_cancel_pressed():
	if !button_pressed:
		emit_signal("cancel_pressed")
		button_pressed = true

func set_label_text(new_value):
	var label := $VBoxContainer/Label
	label.text = new_value
