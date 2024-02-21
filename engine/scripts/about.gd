extends Control

@onready var back_to_menu_button := $MyPanel/VBoxContainer/ExternalButtonsBox/HBoxContainer/MyButton
@onready var label := $MyPanel/VBoxContainer/ScrollPanelBox/MarginContainer/RichTextLabel
var label_position : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	back_to_menu_button.grab_focus()
	back_to_menu_button.pressed.connect(go_to_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global.control_manage_phone_rotation(self)
	
	if Input.is_action_just_pressed("back"):
		go_to_menu()
	if Input.is_action_pressed("ui_up"):
		label_position = clampf(label_position - 0.1, 0, label.get_line_count() - 1)
		label.scroll_to_line(label_position)
	if Input.is_action_pressed("ui_down"):
		label_position = clampf(label_position + 0.1, 0, label.get_line_count())
		label.scroll_to_line(label_position)

func go_to_menu():
	get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")
