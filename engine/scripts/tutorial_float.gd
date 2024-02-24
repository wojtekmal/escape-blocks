extends CanvasLayer

@export_multiline var text : String
@export_multiline var text_mobile : String
var current_page : int = 0
@onready var close_button = $HBoxContainer/VBoxContainer/MarginContainer/MyPanel/VBoxContainer/TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $HBoxContainer/VBoxContainer/MarginContainer/MyPanel/VBoxContainer/Label
	
	if global.is_mobile():
		label.text = text_mobile
	else:
		label.text = text
	
	$HBoxContainer/VBoxContainer/MarginContainer/MyPanel/VBoxContainer/TextureButton.grab_focus()
	$HBoxContainer/VBoxContainer/MarginContainer/MyPanel/VBoxContainer/TextureButton.pressed.connect(close_panel)
	$Control/MyOpaqueButton.pressed.connect(open_panel)
	
	if global.is_mobile():
		$Control/MyOpaqueButton.position = Vector2($Control.size.x - 512, 0)
		$Control/MyOpaqueButton.size = Vector2(256, 256)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("tutorial"):
		open_panel()
	
	var vbox = $HBoxContainer/VBoxContainer
	var float_box = $HBoxContainer/VBoxContainer/MarginContainer
	var label = $HBoxContainer/VBoxContainer/MarginContainer/MyPanel/VBoxContainer/Label
	
	var default_screen_x = ProjectSettings.get_setting("display/window/size/viewport_width")
	var default_screen_y = ProjectSettings.get_setting("display/window/size/viewport_height")
	var default_ratio = 1.0 * default_screen_y / default_screen_x
	
	var actual_screen_x = $HBoxContainer.size.x
	var actual_screen_y = $HBoxContainer.size.y
	var actual_ratio = 1.0 * actual_screen_y / actual_screen_x
	
	if actual_ratio > 1:
		$HBoxContainer/Container.size_flags_stretch_ratio = 1
		$HBoxContainer/Container3.size_flags_stretch_ratio = 1
		vbox.size_flags_stretch_ratio = 10
		
		$HBoxContainer/VBoxContainer/Container.size_flags_stretch_ratio = 1
		$HBoxContainer/VBoxContainer/Container2.size_flags_stretch_ratio = 14
		float_box.size_flags_stretch_ratio = 8
		
		label.label_settings.font_size = int(24 * pow(log_modulus(default_ratio / actual_ratio), 0.5))
	else:
		$HBoxContainer/Container.size_flags_stretch_ratio = 14
		$HBoxContainer/Container3.size_flags_stretch_ratio = 1
		vbox.size_flags_stretch_ratio = 8
		
		$HBoxContainer/VBoxContainer/Container.size_flags_stretch_ratio = 1
		$HBoxContainer/VBoxContainer/Container2.size_flags_stretch_ratio = 1
		float_box.size_flags_stretch_ratio = 10
		
		label.label_settings.font_size = int(24 * pow(log_modulus(default_ratio / actual_ratio), 0.5))
		
		if global.is_mobile():
			print("adjusting size because mobile")
			label.label_settings.font_size *= 1.7
			print(label.label_settings.font_size)
	
	if get_viewport().gui_get_focus_owner() == null || get_viewport().gui_get_focus_owner().is_visible_in_tree() == false:
		$HBoxContainer/VBoxContainer/MarginContainer/MyPanel/VBoxContainer/TextureButton.grab_focus()

func log_modulus(value):
	if value > 1:
		return value
	else:
		return 1 / value

func close_panel():
	$HBoxContainer.visible = false
	$Control.visible = true

func open_panel():
	$HBoxContainer.visible = true
	$Control.visible = false
	$HBoxContainer/VBoxContainer/MarginContainer/MyPanel/VBoxContainer/TextureButton.grab_focus()

func manage_phone_rotation():
	global.control_manage_phone_rotation($HBoxContainer)
	global.control_manage_phone_rotation($Control)
