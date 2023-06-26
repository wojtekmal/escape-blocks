@tool
extends Node2D

signal button_pressed

# Called when the node enters the scene tree for the first time.
func _ready():
	$TextureButton.pressed.connect(on_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func on_pressed():
	emit_signal("button_pressed", "Random")
