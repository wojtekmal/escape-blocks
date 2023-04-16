@tool
extends MarginContainer

@export_multiline var label_text : String = "" : set = set_label_text
@export var custom_method : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var checkbox = $HBoxContainer/CheckBox
	checkbox.toggled.connect(checkbox_toggled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	label_text = new_value
	var label = $HBoxContainer/Label
	label.text = new_value

func checkbox_toggled(new_value: bool):
	if !has_method(custom_method):
		print("This checkboxes custom method doesn't exist. ~wojtekmal")
	call(custom_method, new_value)

func switch_rotation(new_value: bool):
	InputMap.action_erase_events("gravity_left")
	InputMap.action_erase_events("gravity_right")
	
	if new_value == false:
		var key = InputEventKey.new()
		key.physical_keycode = KEY_LEFT
		InputMap.action_add_event("gravity_left", key)
		var key2 = InputEventKey.new()
		key2.physical_keycode = KEY_RIGHT
		InputMap.action_add_event("gravity_left", key2)
	else:
		var key = InputEventKey.new()
		key.physical_keycode = KEY_RIGHT
		InputMap.action_add_event("gravity_left", key)
		var key2 = InputEventKey.new()
		key2.physical_keycode = KEY_LEFT
		InputMap.action_add_event("gravity_left", key2)
