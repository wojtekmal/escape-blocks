extends MarginContainer

signal ok_pressed
signal cancel_pressed

var button_pressed : bool = false
var real_pos := Vector2i(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	var ok_button := $VBoxContainer/HBoxContainer/OkBox/TextureButton
	var cancel_button := $VBoxContainer/HBoxContainer/CancelBox/TextureButton
	
	ok_button.button_down.connect(on_ok_pressed)
	cancel_button.pressed.connect(on_cancel_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event is InputEventMouseButton:
		if (!(event.position.x >= real_pos.x && event.position.x <= real_pos.x + size.x) ||
		!(event.position.y >= real_pos.y && event.position.y <= real_pos.y + size.y)):
			queue_free()

func on_ok_pressed():
	if !button_pressed:
		emit_signal("ok_pressed")
		button_pressed = true
		queue_free()

func on_cancel_pressed():
	if !button_pressed:
		emit_signal("cancel_pressed")
		button_pressed = true
		queue_free()

func set_label_text(new_value):
	var label := $VBoxContainer/Label
	label.text = new_value
