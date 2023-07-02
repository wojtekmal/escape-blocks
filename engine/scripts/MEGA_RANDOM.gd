@tool
extends Node2D

signal button_pressed

func _ready():
	$TextureButton.pressed.connect(on_pressed)

func on_pressed():
	emit_signal("button_pressed", "MEGA RANDOM")
