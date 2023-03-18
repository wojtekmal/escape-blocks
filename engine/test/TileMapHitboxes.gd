extends TileMap

@onready var _hitbox := preload("res://test/hitbox.tscn")
@export var slow := false
# Called when the node enters the scene tree for the first time.
func _ready():
	if slow:
		for tile in get_used_cells(0):
			var new_hitbox := _hitbox.instantiate()
			add_child(new_hitbox)
			new_hitbox.position = map_to_local(tile)
			new_hitbox.vertical = [-7.5, 7,5]
			new_hitbox.horizontal = [-7.5, 7,5]
