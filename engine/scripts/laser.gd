extends Node2D
signal player_reached_finish_area

@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var is_falling := true : set = set_is_falling
@export var start_rotations : int = 0

func _ready():
	add_to_group("wasd")

func _enter_tree():
	$Node2D.rotation = start_rotations * PI / 2

func _physics_process(delta):
	$Node2D/laserBEAM.clear_points()
	
	$Node2D/laserBEAM.add_point(Vector2(-30, 0))
	if($Node2D/RayCast2D.is_colliding()):
		$Node2D/laserBEAM.add_point(($Node2D/RayCast2D.get_collision_point() - position).rotated(-rotation - $Node2D.rotation) - Vector2.LEFT * 10)
	else:
		$Node2D/laserBEAM.add_point(Vector2(1000, 0))

func set_is_falling(new_value):
	pass
	#if new_value == true:
		#push_error("You are changing Finish's is_falling, which is always false.")
	
func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2i(board_cords.x * 64 + 32 - board_dimensions.x * 32, board_cords.y * 64 + 32 - board_dimensions.y * 32))

func get_real_class():
	return "Laser"
