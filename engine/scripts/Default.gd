class_name default
extends Node2D

func _ready():
	var Player = get_parent().get_node("Player")
	if Player != null:
		Player.connect("rotate_gravity", self, "_on_Player_rotate_gravity")

func _on_Player_rotate_gravity(rotations_to_perform) -> void:
	change_gravity(rotations_to_perform)

func change_gravity(rotations: int):
	for i in range(rotations):
		rotation_degrees += 90
		position = position.rotated(deg2rad(90))
