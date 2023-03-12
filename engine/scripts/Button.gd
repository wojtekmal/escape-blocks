extends default

@onready var _hitbox := $hitbox
@onready var _pressed_sprite := $pressed
@onready var _released_sprite := $released
signal pressed
signal released
var bodies := 0

func _ready() -> void:
	_pressed_sprite.visible = false
	_released_sprite.visible = true

func on_press():
	_released_sprite.visible = false
	_pressed_sprite.visible = true
	emit_signal("pressed")
	
func on_release():
	_released_sprite.visible = true
	_pressed_sprite.visible = false
	emit_signal("released")

func _on_hitbox_body_entered(body: Node) -> void:
	if bodies == 0:
		on_press()
	bodies += 1

func _on_hitbox_body_exited(body: Node) -> void:
	bodies -= 1
	if bodies == 0:
		on_release()
