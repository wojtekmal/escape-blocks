extends entity

func _physics_process(delta: float) -> void:
	default_phisics(delta)

func _ready():
	var Player = get_parent().get_node("Player")
	Player.connect("rotate_gravity", self, "_on_Player_rotate_gravity")

func _on_Player_rotate_gravity(rotations_to_perform) -> void:
	change_gravity(rotations_to_perform, keep_speed_after_rotation)
