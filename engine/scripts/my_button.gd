@tool
extends MarginContainer

signal pressed

@export_multiline var label_text : String = "" : set = set_label_text
@export var disabled : bool = false : set = set_disabled
#@export var action : String = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.pressed.connect(emit_pressed)
	
	var margin_value = 0
	var margin_left = get_theme_constant("margin_left")
	var margin_right = get_theme_constant("margin_right")
	var margin_top = get_theme_constant("margin_top")
	var margin_bottom = get_theme_constant("margin_bottom")

	var x_size = size.x - margin_left - margin_right
	var y_size = size.y - margin_top - margin_bottom
	
	if x_size > y_size:
		$LabelBox.add_theme_constant_override("margin_left", 5.0 * y_size / 32)
		$LabelBox.add_theme_constant_override("margin_right", 5.0 * y_size / 32)
		$HBoxContainer/VBoxContainer.size_flags_stretch_ratio = 5.0 * y_size / x_size
		$HBoxContainer/VBoxContainer2.size_flags_stretch_ratio = 32 - 10.0 * y_size / x_size
		$HBoxContainer/VBoxContainer3.size_flags_stretch_ratio = 5.0 * y_size / x_size
		$HBoxContainer/VBoxContainer/TextureRect.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer/TextureRect2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer/TextureRect3.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer2/TextureRect.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer2/TextureRect2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer2/TextureRect3.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer3/TextureRect.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer3/TextureRect2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer3/TextureRect3.size_flags_stretch_ratio = 5
	else:
		$LabelBox.add_theme_constant_override("margin_left", 5.0 * x_size / 32)
		$LabelBox.add_theme_constant_override("margin_right", 5.0 * x_size / 32)
		$HBoxContainer/VBoxContainer.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer3.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer/TextureRect.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer/TextureRect2.size_flags_stretch_ratio = 32 - 10.0 * x_size / y_size
		$HBoxContainer/VBoxContainer/TextureRect3.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer2/TextureRect.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer2/TextureRect2.size_flags_stretch_ratio = 32 - 10.0 * x_size / y_size
		$HBoxContainer/VBoxContainer2/TextureRect3.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer3/TextureRect.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer3/TextureRect2.size_flags_stretch_ratio = 32 - 10.0 * x_size / y_size
		$HBoxContainer/VBoxContainer3/TextureRect3.size_flags_stretch_ratio = 5.0 * x_size / y_size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var margin_value = 0
	var margin_left = get_theme_constant("margin_left")
	var margin_right = get_theme_constant("margin_right")
	var margin_top = get_theme_constant("margin_top")
	var margin_bottom = get_theme_constant("margin_bottom")

	var x_size = size.x - margin_left - margin_right
	var y_size = size.y - margin_top - margin_bottom
	
	if x_size > y_size:
		$LabelBox.add_theme_constant_override("margin_left", 5.0 * y_size / 32)
		$LabelBox.add_theme_constant_override("margin_right", 5.0 * y_size / 32)
		$HBoxContainer/VBoxContainer.size_flags_stretch_ratio = 5.0 * y_size / x_size
		$HBoxContainer/VBoxContainer2.size_flags_stretch_ratio = 32 - 10.0 * y_size / x_size
		$HBoxContainer/VBoxContainer3.size_flags_stretch_ratio = 5.0 * y_size / x_size
		$HBoxContainer/VBoxContainer/TextureRect.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer/TextureRect2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer/TextureRect3.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer2/TextureRect.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer2/TextureRect2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer2/TextureRect3.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer3/TextureRect.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer3/TextureRect2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer3/TextureRect3.size_flags_stretch_ratio = 5
	else:
		$LabelBox.add_theme_constant_override("margin_left", 5.0 * x_size / 32)
		$LabelBox.add_theme_constant_override("margin_right", 5.0 * x_size / 32)
		$HBoxContainer/VBoxContainer.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer2.size_flags_stretch_ratio = 22
		$HBoxContainer/VBoxContainer3.size_flags_stretch_ratio = 5
		$HBoxContainer/VBoxContainer/TextureRect.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer/TextureRect2.size_flags_stretch_ratio = 32 - 10.0 * x_size / y_size
		$HBoxContainer/VBoxContainer/TextureRect3.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer2/TextureRect.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer2/TextureRect2.size_flags_stretch_ratio = 32 - 10.0 * x_size / y_size
		$HBoxContainer/VBoxContainer2/TextureRect3.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer3/TextureRect.size_flags_stretch_ratio = 5.0 * x_size / y_size
		$HBoxContainer/VBoxContainer3/TextureRect2.size_flags_stretch_ratio = 32 - 10.0 * x_size / y_size
		$HBoxContainer/VBoxContainer3/TextureRect3.size_flags_stretch_ratio = 5.0 * x_size / y_size

func set_label_text(new_value):
	label_text = new_value
	#$LabelBox/Label.text = new_value
	$LabelBox/Label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	$LabelBox/Label.push_font(load("res://fonts/conthrax/conthrax-sb.otf"), 36)
	$LabelBox/Label.push_color(Color(0,0,0,1))
	$LabelBox/Label.append_text(new_value)

func emit_pressed():
	emit_signal("pressed")

func set_disabled(new_value):
	$TextureButton.disabled = new_value
	disabled = new_value
