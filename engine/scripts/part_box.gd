@tool
extends MarginContainer

@export_multiline var label_text := "" : set = set_label_text
@export var part_visible : bool = false : set = set_part_visible
@export var part_new : bool = false : set = set_part_new

# Called when the node enters the scene tree for the first time.
func _ready():
	part_visible = false
	
	if global.is_mobile():
		$VBoxContainer/LabelBox/Label.label_settings.font_size = 48

func set_label_text(new_value):
	label_text = new_value
	var label := $VBoxContainer/LabelBox/Label
	label.text = new_value

func set_part_visible(new_value):
	part_visible = new_value
	var part_texture = $VBoxContainer/FrameBox/RatioPartBox/Part
	part_texture.visible = new_value

func set_part_new(new_value):
	part_new = new_value
	var part_texture = $VBoxContainer/FrameBox/RatioPartBox/Part
	#print(part_texture)
	#part_texture.flip_h = new_value
	var animation := $VBoxContainer/FrameBox/RatioPartBox/Part/AnimationPlayer
	animation.play("make_part_appear")
