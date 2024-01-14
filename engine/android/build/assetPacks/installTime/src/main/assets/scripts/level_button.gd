class_name LevelButton
extends TextureButton

signal refresh_map
signal level_button_pressed

@onready var needed_part_display := $VBoxContainer/HBoxContainer
var real_name = "NULL"
var normal_texture := preload("res://textures/temporary_level_map_button.png")
var disabled_texture := preload("res://textures/temporary_level_map_button_disabled.png")

func _ready():
	var label = $LabelNode/Label
	var part_label := $VBoxContainer/HBoxContainer/Label
	
	set_label_text(name)
	#print(global.levels[label.text]["unlocked"])
	#print(name)
	pressed.connect(on_button_pressed)
	
	needed_part_display.modulate = Color8(255,255,255,255)
	modulate = Color8(255,255,255,255)
	
	if !global.levels.has(label.text):
		pass
	elif global.levels[label.text]["unlocked"] == 2:
		disabled = false
		needed_part_display.modulate = Color8(0,0,0,0)
		texture_normal = normal_texture
		
		var done_part := $DonePart
#		var time_part_1 := $TimePart1
#		var time_part_2 := $TimePart2
		var rotation_part_1 := $RotationPart1
		var rotation_part_2 := $RotationPart2
		
		done_part.visible = true
#		time_part_1.visible = true
#		time_part_2.visible = true
		rotation_part_1.visible = true
		rotation_part_2.visible = true
		
		if global.levels[label.text]["finished_parts"] >= 1:
			done_part.self_modulate = Color8(255, 255, 255, 255)
#		if global.levels[label.text]["time_parts"] >= 1:
#			time_part_1.self_modulate = Color8(255, 255, 255, 255)
#		if global.levels[label.text]["time_parts"] >= 2:
#			time_part_2.self_modulate = Color8(255, 255, 255, 255)
		if global.levels[label.text]["rotation_parts"] >= 1:
			rotation_part_1.self_modulate = Color8(255, 255, 255, 255)
		if global.levels[label.text]["rotation_parts"] >= 2:
			rotation_part_2.self_modulate = Color8(255, 255, 255, 255)
		
	elif global.levels[label.text]["unlocked"] == 1:
		disabled = false
		texture_normal = disabled_texture
		var done_part := $DonePart
		var time_part_1 := $TimePart1
		var time_part_2 := $TimePart2
		var rotation_part_1 := $RotationPart1
		var rotation_part_2 := $RotationPart2
		done_part.visible = false
#		time_part_1.visible = false
#		time_part_2.visible = false
		rotation_part_1.visible = false
		rotation_part_2.visible = false
	else:
		disabled = true
		texture_normal = disabled_texture
		modulate = Color8(100,100,100)
		var done_part := $DonePart
		var time_part_1 := $TimePart1
		var time_part_2 := $TimePart2
		var rotation_part_1 := $RotationPart1
		var rotation_part_2 := $RotationPart2
		done_part.visible = false
#		time_part_1.visible = false
#		time_part_2.visible = false
		rotation_part_1.visible = false
		rotation_part_2.visible = false
	
	if global.levels_data.has(label.text):
		part_label.text = str(global.levels_data[label.text]["part_price"])
		
		if global.levels_data[label.text]["part_price"] == 0:
			needed_part_display.modulate = Color8(0,0,0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_focus():
		self_modulate = Color8(255,234,84)
	else:
		self_modulate = Color(1,1,1)

func set_label_text(new_value):
	var label = $LabelNode/Label
	if(global.levels_data.has(new_value)):
#		print(new_value, " name")
		real_name = new_value
		label.text = new_value
	
	label.position.x = -label.size.x / 2 * label.scale.x
	label.position.y = -label.size.y / 2 * label.scale.y

func on_button_pressed():
	var label = $LabelNode/Label
	
	if global.levels[label.text]["unlocked"] == 1:
		var confirm_buy_level = load("res://map_stuff/confirm_buy_level.tscn").instantiate()
		confirm_buy_level.ok_pressed.connect(on_level_bought)
		confirm_buy_level.set_label_text("Open level " + str(label.text) +\
		"\nfor " + str(global.levels_data[label.text]["part_price"]) + " parts?")
		confirm_buy_level.real_pos = position
		add_child(confirm_buy_level)
	else:
		print("pressed: " +  label.text)
		emit_signal("level_button_pressed", label.text)

func _on_renamed():
	set_label_text(name)

func on_level_bought():
	var label = $LabelNode/Label
	
	if global.part_count < global.levels_data[label.text]["part_price"]:
		return
	
	global.part_count -= global.levels_data[label.text]["part_price"]
	global.levels[label.text]["unlocked"] = 2
	texture_normal = normal_texture
	emit_signal("refresh_map")
