extends Camera2D

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;
var zoom_factor = 1.0
var events = {}
var last_drag_distance = 0
var zoom_sensitivity = 10
@export var ZOOM_SPEED = PI * 1.5
@export var ZOOM_MIN = 0.1
@export var ZOOM_MAX = 7.0

func _unhandled_input(event: InputEvent, delta = get_process_delta_time()):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled();
		if event.is_pressed():
			_previousPosition = event.position;
			_moveCamera = true;
		else:
			_moveCamera = false;
	elif event is InputEventMouseMotion && _moveCamera:
		get_viewport().set_input_as_handled();
		position += (_previousPosition - event.position).rotated(global.phone_rotation * PI / 2) / zoom_factor;
		_previousPosition = event.position;
		position.x = max(position.x, -8000)
		position.x = min(position.x, 15000)
		position.y = max(position.y, -8000)
		position.y = min(position.y, 10000)
	elif event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			pass
		elif events.size() == 2:
			var drag_distance = events[0].position.distance_to(events[1].position)
			
			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
				var new_zoom = (1 - ZOOM_SPEED * delta) if drag_distance < last_drag_distance else (1 + ZOOM_SPEED * delta)
				global.zoom_factor *= new_zoom
			
			last_drag_distance = drag_distance
			events = {}
