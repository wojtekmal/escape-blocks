extends Node2D
@onready var _hitbox := $hitbox
@onready var button := $Shaded/Button
signal pressed
signal released
var bodies := 0

@export var board_cords: Vector2i : set = set_board_cords
@export var board_dimensions: Vector2i : set = set_board_dimensions
@export var start_rotations : int = 1
@export var is_pressed : bool = false

var colors := {
	0 : Color.WHITE,
	1 : Color.RED,
	2 : Color.GREEN,
	3 : Color.BLUE,
}
var color
var delay := 0.6
var pressed_for := 0.6

func set_board_dimensions(newValue):
	board_dimensions = newValue
	set_board_cords(board_cords)

func set_board_cords(newValue):
	board_cords = newValue
	set_position(Vector2i(board_cords.x * 64 + 32 - board_dimensions.x * 32, board_cords.y * 64 + 32 - board_dimensions.y * 32))

func _ready():
	add_to_group("wasd")
	add_to_group("button " + str(start_rotations))
	$Shaded.material.set_shader_parameter(
		"u_color", 
		colors[start_rotations]
	)
	if start_rotations == 0:
		$Shaded.material.set_shader_parameter("rgb", true)

func on_press():
	show_particles(true)
	emit_signal("pressed")
	
func on_release():
	show_particles(false)
	emit_signal("released")

func show_particles(value := true):
	$Shaded/Normal.emitting = value

func _process(delta):
	var overlapping = $hitbox.get_overlapping_bodies()
	if $hitbox.has_overlapping_bodies():
		$Shaded/TextureProgressBar.value = 1.0 - (pressed_for) / delay
		if pressed_for > 0 and pressed_for - delta < 0:
			on_press()
		pressed_for -= delta
	else:
		$Shaded/TextureProgressBar.value = 0.0
		if pressed_for < 0:
			on_release()
		pressed_for = delay
