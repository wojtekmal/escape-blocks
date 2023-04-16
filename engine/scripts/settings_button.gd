@tool
extends MarginContainer

@export_multiline var label_text : String = "" : set = set_label_text
@export var custom_method : String = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	var button = $HBoxContainer/MarginContainer/TextureButton
	button.pressed.connect(button_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	label_text = new_value
	var label = $HBoxContainer/MarginContainer/MarginContainer/Label
	label.text = new_value

func button_pressed():
	if !has_method(custom_method):
		print("This button's custom method doesn't exist. ~wojtekmal")
		return
	call(custom_method)

func reset_progress_press():
	print("check")
	var confirmation_popup = preload("res://menu_stuff/confirmation_popup.tscn").instantiate()
	confirmation_popup.ok_pressed.connect(reset_progress)
	get_tree().get_root().add_child(confirmation_popup)

func reset_progress():
	for level_name in global.levels_data:
		global.levels[level_name] = {
			"unlocked": false,
			"finished_parts": 0,
			"rotation_parts": 0,
			"time_parts": 0,
		}
	
	global.levels["1"]["unlocked"] = true
	global.current_level = "1"
	global.save()
