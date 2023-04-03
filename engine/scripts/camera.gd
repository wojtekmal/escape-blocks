extends Camera2D
class_name CameraZoom

#camera controll
@export var ZOOM_SPEED = 2
@export var ZOOM_MIN = 0.03
@export var ZOOM_MAX = 3000
var _zoom_factor = 1

func _process(_delta) -> void:
	zoom_camera()

func _input(event : InputEvent, delta = get_physics_process_delta_time()) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_DOWN:
					_zoom_factor -= ZOOM_SPEED * delta * _zoom_factor
				MOUSE_BUTTON_WHEEL_UP:
					_zoom_factor += ZOOM_SPEED * delta * _zoom_factor

func zoom_camera():
	zoom.x = _zoom_factor
	zoom.y = _zoom_factor
	_zoom_factor = min(ZOOM_MAX, _zoom_factor)
	_zoom_factor = max(ZOOM_MIN, _zoom_factor)
