@tool
extends Control

signal toggled

@export_multiline var label_text : String = "" : set = set_label_text

# Called when the node enters the scene tree for the first time.
func _ready():
	$MarginContainer/HBoxContainer/CheckButton.toggled.connect(emit_toggled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_visible_in_tree():
		return
	
	if has_focus():
		modulate = Color(0.6,1,0.6)
	else:
		modulate = Color(1,1,1)
	
	var check_button := $MarginContainer/HBoxContainer/CheckButton
	
	if has_focus() && Input.is_action_just_pressed("ui_accept"):
		check_button.button_pressed = !check_button.button_pressed
	elif has_focus() && Input.is_action_just_pressed("ui_left"):
		check_button.button_pressed = false
	elif has_focus() && Input.is_action_just_pressed("ui_right"):
		check_button.button_pressed = true
	
	var x_size = size.x# - margin_left - margin_right
	var y_size = size.y# - margin_top - margin_bottom
	
	custom_minimum_size.y = $MarginContainer/HBoxContainer/Label.size.y + 10

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
		#$LabelBox.add_theme_constant_override("margin_left", 5.0 * x_size / 32)
		#$LabelBox.add_theme_constant_override("margin_right", 5.0 * x_size / 32)
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
	$MarginContainer/HBoxContainer/Label.clear()
	$MarginContainer/HBoxContainer/Label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	$MarginContainer/HBoxContainer/Label.push_font(load("res://fonts/conthrax/conthrax-sb.otf"), 36)
	$MarginContainer/HBoxContainer/Label.push_color(Color(0,0,0,1))
	$MarginContainer/HBoxContainer/Label.append_text(new_value)

func emit_toggled():
	emit_signal("toggled")
