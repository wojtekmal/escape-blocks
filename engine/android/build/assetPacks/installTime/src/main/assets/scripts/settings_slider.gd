@tool
extends MarginContainer

signal changed

@export var action : String = ""
@export_multiline var label_text : String = "" : set = set_label_text
@export var range : Vector2 = Vector2(0, 100) : set = set_range

func _ready():
	var h_slider := $HBoxContainer/VBoxContainer/HSlider
	h_slider.value_changed.connect(on_value_changed)
	
	if global.settings.has(action):
		h_slider.value = global.settings[action]

func _process(delta):
	pass

func on_value_changed(new_value):
	emit_signal("changed", action, new_value)

func set_label_text(new_value):
	label_text = new_value
	var label = $HBoxContainer/Label
	label.text = new_value

func set_range(new_value):
	range = new_value
	
	var h_slider = $HBoxContainer/VBoxContainer/HSlider
	h_slider.min_value = new_value.x
	h_slider.max_value = new_value.y
	var min_label = $HBoxContainer/VBoxContainer/HBoxContainer/MinLabel
	var max_label = $HBoxContainer/VBoxContainer/HBoxContainer/MaxLabel
	min_label.text = str(new_value.x)
	max_label.text = str(new_value.y)
