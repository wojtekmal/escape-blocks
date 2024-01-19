extends Node2D

@onready var level_button = preload("res://map_stuff/level_button.tscn")
var last_pos := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	global.current_level = "1"
	global.save()
	load_all()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func load_all():
	var path = "res://levels/"
	add_levels(path, "")

func add_levels(path, dirname):
	$Panel.visible = true
	var rows = 6
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				if file_name != "maps":
					add_levels(path + file_name + "/", dirname + file_name + "/")
			else:
				file_name = file_name.replace(".remap" , "")
				file_name = file_name.replace(".tscn" , "")
				
				global.levels_data[dirname + file_name] = {"resource":load(path + file_name + ".tscn"), "unlocks": [], "part_price": 0,}
				global.levels[dirname + file_name] = {
					"unlocked": 2,
					"finished_parts": 0,
					"rotation_parts": 0,
					#"time_parts": 0,
				}
#				global.levels[dirname + file_name]["unlocked"] = true
#				print(dirname + file_name, " ",  global.levels_data[dirname + file_name])
				
				var new_button = level_button.instantiate()
				new_button.position = Vector2i(last_pos % rows * 300 + 100, last_pos / rows * 78 + 800) + Vector2i.UP * 700
				if (last_pos/rows) % 2 == 0: 
					new_button.position.x += 150
				new_button.on_level_bought()
				last_pos += 1
				
				new_button.name = dirname + "/" + file_name
				new_button.set_label_text(dirname + file_name)
				new_button.level_button_pressed.connect(on_level_button_pressed)
				
				add_child(new_button)
				print(new_button.position)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	$Panel.position = Vector2i.UP * 700 - Vector2i(150, 100)
	$Panel.size = Vector2(rows * 300 + 150, ((last_pos + rows -1 )/ rows) * 78 + 100)
	
func on_level_button_pressed(level_name):
	#print("Level map detected tutorial button.")
	print(level_name)
	global.current_level = level_name
	get_tree().change_scene_to_file("res://levels/level_restart.tscn")
