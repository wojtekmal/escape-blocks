extends Button

@export_multiline var label_text : String = "" : set = set_label_text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !is_visible_in_tree():
		return
	
	if has_focus():
		modulate = Color(0.6,1,0.6)
	else:
		modulate = Color(1,1,1)

	var margin_value = 0
	var margin_left = get_theme_constant("margin_left")
	var margin_right = get_theme_constant("margin_right")
	var margin_top = get_theme_constant("margin_top")
	var margin_bottom = get_theme_constant("margin_bottom")

	var x_size = size.x# - margin_left - margin_right
	var y_size = size.y# - margin_top - margin_bottom
	
	custom_minimum_size.y = $LabelBox/Label.size.y + 20

func set_label_text(new_value):
	#if $LabelBox/Label == null:
	#	return
	label_text = new_value
	#print(new_value)
	#$LabelBox/Label.text = new_value
	$LabelBox/Label.clear()
	$LabelBox/Label.push_paragraph(HORIZONTAL_ALIGNMENT_CENTER)
	$LabelBox/Label.push_font(load("res://fonts/conthrax/conthrax-sb.otf"), 36)
	$LabelBox/Label.push_color(Color(0.8,0.8,0.8,0.5))
	$LabelBox/Label.append_text(new_value)

