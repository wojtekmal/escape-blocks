extends Node2D

func _process(delta):
	var default_screen_x = ProjectSettings.get_setting("display/window/size/viewport_width")
	var default_screen_y = ProjectSettings.get_setting("display/window/size/viewport_height")
	var default_ratio = 1.0 * default_screen_y / default_screen_x
	
	var actual_screen_x = get_viewport().get_visible_rect().size.x
	var actual_screen_y = get_viewport().get_visible_rect().size.y
	var actual_ratio = 1.0 * actual_screen_y / actual_screen_x
	
	var scale_float = 8 * max(actual_ratio / default_ratio, default_ratio / actual_ratio)
	scale = Vector2(scale_float, scale_float)

func _ready():
	off()

func off():
	$Stars.queue_free()
	$Stars2.queue_free()
	$Stars3.queue_free()
	
