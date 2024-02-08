class_name LevelButton
extends TextureButton

signal refresh_map
signal level_button_pressed

var real_name = "NULL"
var normal_texture := preload("res://textures/temporary_level_map_button.png")
var disabled_texture := preload("res://textures/temporary_level_map_button_disabled.png")

func _ready():
	var label = $LabelNode/Label
	
	set_label_text(name)
	pressed.connect(on_button_pressed)
	
	modulate = Color8(255,255,255,255)
	
	if !global.levels.has(label.text):
		pass
	elif global.levels[label.text]["unlocked"] == 2:
		disabled = false
		texture_normal = normal_texture
		
		var done_part := $DonePart
		var rotation_part_1 := $RotationPart1
		var rotation_part_2 := $RotationPart2
		
		done_part.visible = true
		rotation_part_1.visible = true
		rotation_part_2.visible = true
		
		if global.levels[label.text]["finished_parts"] >= 1:
			done_part.self_modulate = Color8(255, 255, 255, 255)
		if global.levels[label.text]["rotation_parts"] >= 1:
			rotation_part_1.self_modulate = Color8(255, 255, 255, 255)
		if global.levels[label.text]["rotation_parts"] >= 2:
			rotation_part_2.self_modulate = Color8(255, 255, 255, 255)
	else:
		disabled = true
		texture_normal = disabled_texture
		modulate = Color8(100,100,100)
		var done_part := $DonePart
		var rotation_part_1 := $RotationPart1
		var rotation_part_2 := $RotationPart2
		done_part.visible = false
		rotation_part_1.visible = false
		rotation_part_2.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if has_focus():
		self_modulate = Color8(255,234,84)
	else:
		self_modulate = Color(1,1,1)

func set_label_text(new_value):
	var label = $LabelNode/Label
	if(global.levels_data.has(new_value)):
		real_name = new_value
		label.text = new_value
	
	label.position.x = -label.size.x / 2 * label.scale.x
	label.position.y = -label.size.y / 2 * label.scale.y

func on_button_pressed():
	var label = $LabelNode/Label
	
	emit_signal("level_button_pressed", label.text)

func _on_renamed():
	set_label_text(name)
