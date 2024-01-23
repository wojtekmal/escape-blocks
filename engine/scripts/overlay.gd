@tool
extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func collapse(x: int):
	if x == 0: return 0
	else: return 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !Engine.is_editor_hint():
		return
	
	var mask_dict = {}
	var delta_x = [-1, 1, 1, -1]
	var delta_y = [-1, -1, 1, 1]
	
	for cell in get_used_cells(1):
		var alternitive_tile = get_cell_alternative_tile(1, cell)
		var atlas_cords = get_cell_atlas_coords(1, cell)
		var source_id = get_cell_source_id(1, cell)
		#var mask = [atlas_cords.x % 2, atlas_cords.x / 2, atlas_cords.y % 2, atlas_cords.y / 2]
		var mask = [0, 0, 0, 0]
		
		for x in range(-1, 2):
			for y in range(-1, 2):
				if x == 0 && y == 0: continue
				var neigh_cords = cell + Vector2i(x, y)
				if get_cell_source_id(1, neigh_cords) == -1: continue
				
				if x <= 0 && y <= 0: mask[0] = 1
				if x >= 0 && y <= 0: mask[1] = 1
				if x >= 0 && y >= 0: mask[2] = 1
				if x <= 0 && y >= 0: mask[3] = 1
		
		set_cell(1, cell, source_id, Vector2i(mask[0] + mask[1]*2, mask[2] + mask[3]*2))
		
		if get_cell_source_id(1, cell + Vector2i(-1, -1)) != -1:
			if get_cell_source_id(1, cell + Vector2i(-1, 0)) == -1:
				mask_dict.get_or_add(cell + Vector2i(-1, 0), 0)
				mask_dict[cell + Vector2i(-1, 0)] |= 2
			
			if get_cell_source_id(1, cell + Vector2i(0, -1)) == -1:
				mask_dict.get_or_add(cell + Vector2i(0, -1), 0)
				mask_dict[cell + Vector2i(0, -1)] |= 8
		
		if get_cell_source_id(1, cell + Vector2i(1, -1)) != -1:
			if get_cell_source_id(1, cell + Vector2i(1, 0)) == -1:
				mask_dict.get_or_add(cell + Vector2i(1, 0), 0)
				mask_dict[cell + Vector2i(1, 0)] |= 1
			
			if get_cell_source_id(1, cell + Vector2i(0, -1)) == -1:
				mask_dict.get_or_add(cell + Vector2i(0, -1), 0)
				mask_dict[cell + Vector2i(0, -1)] |= 4
	
	for cell in get_used_cells(3):
		erase_cell(3, cell)
	
	for cell in mask_dict:
		#print(cell)
		var mask = mask_dict[cell]
		#print(mask)
		set_cell(3, cell, 7, Vector2i(collapse(mask & 1) + collapse(mask & 2)*2, collapse(mask & 4) + collapse(mask & 8)*2))
