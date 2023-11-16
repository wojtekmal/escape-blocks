extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay := $MarginContainer/AspectRatioContainer/MarginContainer2/TileMap
	var screen_size : Vector2 = $MarginContainer.size
	var scale = min(screen_size.x, screen_size.y) / 96
	overlay.scale = Vector2(scale, scale)
	$MarginContainer/AspectRatioContainer/MarginContainer2/HBoxContainer/VBoxContainer3/Start.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	manage_phone_rotation()

func manage_phone_rotation():
	if OS.get_name() != "Android":
		return
	
	var viewport_size = get_viewport().get_visible_rect().size
	
	if global.phone_rotation == 0:
		pivot_offset = Vector2(0,0)
		rotation = 0
		size = Vector2(viewport_size.x, viewport_size.y)
	elif global.phone_rotation == 1:
		pivot_offset = Vector2(viewport_size.y / 2, viewport_size.y / 2)
		rotation = 3 * PI / 2
		size = Vector2(viewport_size.y, viewport_size.x)
	elif global.phone_rotation == 2:
		pivot_offset = Vector2(viewport_size.x / 2, viewport_size.y / 2)
		rotation = PI
		size = Vector2(viewport_size.x, viewport_size.y)
	elif global.phone_rotation == 3:
		pivot_offset = Vector2(viewport_size.x / 2, viewport_size.x / 2)
		rotation = PI / 2
		size = Vector2(viewport_size.y, viewport_size.x)
