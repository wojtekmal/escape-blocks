@tool
class_name MyTileMap
extends TileMap
@export var tilemap_dimensions : Vector2i : set = set_tilemap_dimensions

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_real_class():
	return "TileMap"

func set_tilemap_dimensions(newValue):
	for i in range(-tilemap_dimensions.x * 4 - 1, tilemap_dimensions.x * 4 + 1):
		set_cell(0, Vector2i(i, tilemap_dimensions.y * 4), -1, Vector2i(0, 0))
		set_cell(0, Vector2i(i, -tilemap_dimensions.y * 4 - 1), -1, Vector2i(0, 0))
	
	for i in range(-tilemap_dimensions.y * 4 - 1, tilemap_dimensions.y * 4 + 1):
		set_cell(0, Vector2i(-tilemap_dimensions.x * 4 - 1, i), -1, Vector2i(0, 0))
		set_cell(0, Vector2i(tilemap_dimensions.x * 4, i), -1, Vector2i(0, 0))
		
	for i in range(-newValue.x * 4 - 1, newValue.x * 4 + 1):
		set_cell(0, Vector2i(i, newValue.y * 4), 0, Vector2i(0, 0))
		set_cell(0, Vector2i(i, -newValue.y * 4 - 1), 0, Vector2i(0, 0))

	for i in range(-newValue.y * 4 - 1, newValue.y * 4 + 1):
		set_cell(0, Vector2i(-newValue.x * 4 - 1, i), 0, Vector2i(0, 0))
		set_cell(0, Vector2i(newValue.x * 4, i), 0, Vector2i(0, 0))
	
	tilemap_dimensions = newValue
