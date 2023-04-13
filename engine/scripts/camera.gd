extends Camera2D
class_name CameraZoom

#camera controll
@export var ZOOM_SPEED = PI * 1.5
@export var ZOOM_MIN = 0.1
@export var ZOOM_MAX = 20.0
var _zoom_factor : float = 0.7

func _process(delta) -> void:
	zoom_camera()
	global_position = lerp(global_position, get_parent().global_position, delta * 0.1)

func _input(event : InputEvent, delta = get_physics_process_delta_time()) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_DOWN:
					_zoom_factor -= ZOOM_SPEED * delta * _zoom_factor
				MOUSE_BUTTON_WHEEL_UP:
					_zoom_factor += ZOOM_SPEED * delta * _zoom_factor

func zoom_camera():
	_zoom_factor = min(ZOOM_MAX, _zoom_factor)
	_zoom_factor = max(ZOOM_MIN, _zoom_factor)
	zoom.x = _zoom_factor
	zoom.y = _zoom_factor
