@tool
extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var overlay := $MarginContainer/AspectRatioContainer/MarginContainer2/TileMap
	var screen_size : Vector2 = $MarginContainer.size
	var scale = min(screen_size.x, screen_size.y) / 96
	overlay.scale = Vector2(scale, scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
