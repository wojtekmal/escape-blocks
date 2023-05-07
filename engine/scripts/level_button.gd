@tool
class_name LevelButton
extends Node2D

signal button_pressed
signal refresh_map

@onready var pressable_button := $TextureButton
@onready var needed_part_display := $TextureButton/VBoxContainer/HBoxContainer
#var is_unlocked : bool = false
#var label_text : String = "" : set = set_label_text

# Called when the node enters the scene tree for the first time.
func _ready():
	var label = $TextureButton/VBoxContainer/Label
	var part_label := $TextureButton/VBoxContainer/HBoxContainer/Label
	
	set_label_text(name)
	#print(global.levels[label.text]["unlocked"])
	#print(name)
	pressable_button.pressed.connect(on_button_pressed)
	
	needed_part_display.modulate = Color8(255,255,255,255)
	modulate = Color8(255,255,255,255)
	
	if !global.levels.has(label.text):
		pass
	elif global.levels[label.text]["unlocked"] == 2:
		pressable_button.disabled = false
		needed_part_display.modulate = Color8(0,0,0,0)
		$TextureButton.texture_normal = load("res://textures/temporary_level_map_button.png")
	elif global.levels[label.text]["unlocked"] == 1:
		pressable_button.disabled = false
		$TextureButton.texture_normal = load("res://textures/temporary_level_map_button_disabled.png")
	else:
		pressable_button.disabled = true
		$TextureButton.texture_normal = load("res://textures/temporary_level_map_button_disabled.png")
		modulate = Color8(255,255,255,100)
	
	print("check")
	
	if global.levels_data.has(label.text):
		part_label.text = str(global.levels_data[label.text]["part_price"])
		print(global.levels_data[label.text]["part_price"])
		
		if global.levels_data[label.text]["part_price"] == 0:
			needed_part_display.modulate = Color8(0,0,0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_label_text(new_value):
	var label = $TextureButton/VBoxContainer/Label
	#print(global.levels)
	#print("checkabc")
	if(global.levels_data.has(new_value)):
		#print("check")
		label.text = new_value
	else:
		#print("check2")
		label.text = "NULL"
	#print("checkdef")

func on_button_pressed():
	var label = $TextureButton/VBoxContainer/Label
	
	if global.levels[label.text]["unlocked"] == 1:
		var confirm_buy_level = load("res://map_stuff/confirm_buy_level.tscn").instantiate()
		confirm_buy_level.ok_pressed.connect(on_level_bought)
		confirm_buy_level.set_label_text("Open level " + str(label.text) +\
		"\nfor " + str(global.levels_data[label.text]["part_price"]) + " parts?")
		confirm_buy_level.real_pos = position
		add_child(confirm_buy_level)
	else:
		emit_signal("button_pressed", label.text)

func _on_renamed():
	set_label_text(name)

func on_level_bought():
	var label = $TextureButton/VBoxContainer/Label
	
	print(global.levels_data[label.text]["part_price"])
	
	if global.part_count < global.levels_data[label.text]["part_price"]:
		return
	
	global.part_count -= global.levels_data[label.text]["part_price"]
	global.levels[label.text]["unlocked"] = 2
	$TextureButton.texture_normal = load("res://textures/temporary_level_map_button.png")
	emit_signal("refresh_map")
