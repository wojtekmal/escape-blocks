extends Camera2D

var _previousPosition: Vector2 = Vector2(0, 0);
var _moveCamera: bool = false;
var zoom_factor = 1.0

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseButton && event.button_index == MOUSE_BUTTON_LEFT:
		get_viewport().set_input_as_handled();
		if event.is_pressed():
			_previousPosition = event.position;
			_moveCamera = true;
		else:
			_moveCamera = false;
	elif event is InputEventMouseMotion && _moveCamera:
		get_viewport().set_input_as_handled();
		position += (_previousPosition - event.position) / zoom_factor;
		_previousPosition = event.position;
		position.x = max(position.x, -8000)
		position.x = min(position.x, 15000)
		position.y = max(position.y, -8000)
		position.y = min(position.y, 10000)
