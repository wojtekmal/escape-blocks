extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var default_screen_x = ProjectSettings.get_setting("display/window/size/viewport_width")
	var default_screen_y = ProjectSettings.get_setting("display/window/size/viewport_height")
	var default_ratio = 1.0 * default_screen_y / default_screen_x
	
	var actual_screen_x = get_viewport().get_visible_rect().size.x
	var actual_screen_y = get_viewport().get_visible_rect().size.y
	var actual_ratio = 1.0 * actual_screen_y / actual_screen_x
	
	var scale_float = 8 * max(actual_ratio / default_ratio, default_ratio / actual_ratio)
	scale = Vector2(scale_float, scale_float)
