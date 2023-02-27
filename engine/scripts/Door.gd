extends RigidBody2D

onready var _collisions := $collisions
onready var _hitbox := $hitbox
onready var _button := $Button
onready var _door_sprite := $door_sprite
var closed := true

signal pressed
signal released
var bodies := 0

func _ready() -> void:
	on_close()

func on_open():
	_collisions.disabled = true
	print("disabled")
	_door_sprite.play("opened")
	
func on_close():
	_collisions.disabled = false
	print("enabled")
	_door_sprite.play("closed")

func _on_hitbox_body_entered(body: Node) -> void:
	bodies += 1

func _on_hitbox_body_exited(body: Node) -> void:
	bodies -= 1
	if bodies == 0 && closed == true:
		on_close()

func _on_Button_pressed():
	on_open()


func _on_Button_released():
	on_close()
