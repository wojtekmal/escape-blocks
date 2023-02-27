extends RigidBody2D

var keep_speed_after_rotation = false
var new_position = Vector2(0, 0)
var changing_gravity := 0

func _ready():
	var Player = get_parent().get_node("Player")
	if Player != null:
		Player.connect("rotate_gravity", self, "_on_Player_rotate_gravity")

func _integrate_forces(state):
	var xform = state.get_transform()
	xform.origin = xform.origin.rotated(PI/2*changing_gravity)
	changing_gravity = 0
	state.set_transform(xform)
	
func _on_Player_rotate_gravity(rotations_to_perform) -> void:
	change_gravity(rotations_to_perform, keep_speed_after_rotation)

func change_gravity(rotations: int, keep_speed: bool = false):
	changing_gravity = rotations
	
