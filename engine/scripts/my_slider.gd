@tool
extends Control

@export_multiline var label_text : String = "" : set = set_label_text

func _ready():
	var x_size = size.x# - margin_left - margin_right
	var y_size = size.y# - margin_top - margin_bottom
	
	custom_minimum_size.y = $MarginContainer/HBoxContainer/RichTextLabel.size.y + 10

	if x_size > y_size:
		$MarginContainer.add_theme_constant_override("margin_left", 5.0 * y_size / 32)
		$MarginContainer.add_theme_constant_override("margin_right", 5.0 * y_size / 32)
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
		$MarginContainer.add_theme_constant_override("margin_left", 5.0 * x_size / 32)
		$MarginContainer.add_theme_constant_override("margin_right", 5.0 * x_size / 32)
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
	if has_focus():
		modulate = Color(0.6,1,0.6)
	else:
		modulate = Color(1,1,1)
	
	if has_focus() && Input.is_action_pressed("ui_left"):
		$MarginContainer/HBoxContainer/HSlider.value -= 100 * delta
	
	if has_focus() && Input.is_action_pressed("ui_right"):
		$MarginContainer/HBoxContainer/HSlider.value += 100 * delta
	
	var margin_value = 0
#	var margin_left = get_theme_constant("margin_left")
#	var margin_right = get_theme_constant("margin_right")
#	var margin_top = get_theme_constant("margin_top")
#	var margin_bottom = get_theme_constant("margin_bottom")

	var x_size = size.x# - margin_left - margin_right
	var y_size = size.y# - margin_top - margin_bottom
	
	custom_minimum_size.y = $MarginContainer/HBoxContainer/RichTextLabel.size.y + 10

	if x_size > y_size:
		$MarginContainer.add_theme_constant_override("margin_left", 5.0 * y_size / 32)
		$MarginContainer.add_theme_constant_override("margin_right", 5.0 * y_size / 32)
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
		$MarginContainer.add_theme_constant_override("margin_left", 5.0 * x_size / 32)
		$MarginContainer.add_theme_constant_override("margin_right", 5.0 * x_size / 32)
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
	$MarginContainer/HBoxContainer/RichTextLabel.clear()
	$MarginContainer/HBoxContainer/RichTextLabel.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	$MarginContainer/HBoxContainer/RichTextLabel.push_font(load("res://fonts/conthrax/conthrax-sb.otf"), 36)
	$MarginContainer/HBoxContainer/RichTextLabel.push_color(Color(0,0,0,1))
	$MarginContainer/HBoxContainer/RichTextLabel.append_text(new_value)
