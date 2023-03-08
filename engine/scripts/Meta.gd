extends RigidBody2D

@export var keep_speed_after_rotation = false
var screen_size : Vector2
var center_of_screen : Vector2

func _ready():
	screen_size = get_viewport_rect().size
	center_of_screen = screen_size / 2
	var Player = get_parent().get_node("Player")
	Player.connect("rotate_gravity",Callable(self,"_on_Player_rotate_gravity"))

func _on_Player_rotate_gravity(rotations_to_perform) -> void:
	change_gravity(rotations_to_perform, keep_speed_after_rotation)

func rotate_90_degrees_CCW(vec : Vector2) -> Vector2:
	vec = Vector2(vec.y, -vec.x)
	return vec

func change_gravity(rotations: int, keep_speed: bool):
	for i in range(rotations):
		position -= center_of_screen
		position = rotate_90_degrees_CCW(position)
		position += center_of_screen
		rotation_degrees -= 90
