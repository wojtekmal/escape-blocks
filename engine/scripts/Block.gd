extends entity

func _physics_process(delta: float) -> void:
	default_phisics(delta)

func _ready():
	rotation_degrees += randi()%4*90
	var Player = get_parent().get_node("Player")
#	if Player != null:
#		Player.connect("rotate_gravity",Callable(self,"_on_Player_rotate_gravity"))

#func _on_Player_rotate_gravity(rotations_to_perform) -> void:
#	change_gravity(rotations_to_perform, keep_speed_after_rotation)
