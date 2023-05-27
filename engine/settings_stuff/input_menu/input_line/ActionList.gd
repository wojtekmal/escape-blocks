extends Control

const InputLine = preload("res://settings_stuff/input_menu/input_line/InputLine.tscn")

func clear():
	for child in get_children():
		child.free()

func add_input_line(action_name, key, is_customizable=false):
	var line = InputLine.instantiate()
	line.initialize(action_name, key, is_customizable)
	add_child(line)
	return line
