extends Camera2D
class_name CameraZoom

#camera controll
@export var ZOOM_SPEED = PI * 1.5
@export var ZOOM_MIN = 0.1
@export var ZOOM_MAX = 7.0

func _ready():
	zoom = Vector2(global.zoom_factor, global.zoom_factor)

func _process(delta) -> void:
	zoom_camera()

func _input(event : InputEvent, delta = get_physics_process_delta_time()) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_DOWN:
					global.zoom_factor -= ZOOM_SPEED * delta * global.zoom_factor
				MOUSE_BUTTON_WHEEL_UP:
					global.zoom_factor += ZOOM_SPEED * delta * global.zoom_factor

func zoom_camera():
	global.zoom_factor = min(ZOOM_MAX, global.zoom_factor)
	global.zoom_factor = max(ZOOM_MIN, global.zoom_factor)
	zoom.x = lerp(zoom.x, global.zoom_factor, get_process_delta_time() * 10)
	zoom.y = lerp(zoom.y, global.zoom_factor, get_process_delta_time() * 10)
	#$background.scale *= Vector2(global.zoom_factor, global.zoom_factor)
