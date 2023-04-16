extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var back_to_menu_button := $VBoxContainer/ExternalButtonsBox/HBoxContainer/BackToMenuBox/BackToMenu
	back_to_menu_button.pressed.connect(go_to_menu)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func go_to_menu():
	get_tree().change_scene_to_file("res://menu_stuff/menu_2.tscn")
