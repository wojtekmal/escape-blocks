@tool
extends MarginContainer

@export_multiline var label_text := "" : set = set_label_text
@export var part_visible : bool = false : set = set_part_visible

# Called when the node enters the scene tree for the first time.
func _ready():
	part_visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	label_text = new_value
	var label := $VBoxContainer/LabelBox/Label
	label.text = new_value

func set_part_visible(new_value):
	part_visible = new_value
	var part_texture = $VBoxContainer/FrameBox/RatioPartBox/Part
	part_texture.visible = new_value
