extends Node2D
@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var start_rotations : int = 1
@export var open := false
signal open_door

var buttons := []
var pressed_buttons := 0;
var buttons_number := 0;

var colors := {
	0 : Color.WHITE,
	1 : Color.RED,
	2 : Color.GREEN,
	3 : Color.BLUE,
}

func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2i(board_cords.x * 64 + 32 - board_dimensions.x * 32, board_cords.y * 64 + 32 - board_dimensions.y * 32))

func _process(delta):
	var can_close : bool = $Area2D.get_overlapping_bodies().size() == 0
	if open == false && pressed_buttons == buttons_number: #opening
		open = true
		$Shaded/Door.visible = false
	elif open == true && pressed_buttons != buttons_number && can_close: #closing
		open = false
		$Shaded/Door.visible = true

func _ready():
	add_to_group("wasd")
	add_to_group("door " + str(start_rotations))
	$Shaded.material.set_shader_parameter(
		"u_color", 
		colors[start_rotations]
	)
	if start_rotations == 0:
		$Shaded.material.set_shader_parameter("rgb", true)
	buttons = get_tree().get_nodes_in_group("button " + str(start_rotations))
	for button in buttons:
		button.connect("pressed", Callable(self, "button_pressed"));
		button.connect("released", Callable(self, "button_released"));
	buttons_number = buttons.size()
	#connect("open_door", Callable(get_parent(), "_on_door_spawn"));
	open = false
	$Shaded/Door.visible = false

#func opened(value := true):
#	if value:
#		#emit_signal("open_door", self, value)
#		$Shaded/Door.visible = false
#	else:
#		#emit_signal("open_door", self, value)
#		$Shaded/Door.visible = true

func button_pressed():
	pressed_buttons += 1

func button_released():
	pressed_buttons -= 1
