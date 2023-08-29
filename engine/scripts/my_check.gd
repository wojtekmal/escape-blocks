@tool
extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_focus():
		modulate = Color(0.6,1,0.6)
	else:
		modulate = Color(1,1,1)
	
	var x_size = size.x# - margin_left - margin_right
	var y_size = size.y# - margin_top - margin_bottom
	
	#custom_minimum_size.y = $LabelBox/Label.size.y + 10

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
