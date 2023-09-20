extends Camera2D
class_name CameraZoom

#camera controll
@export var ZOOM_SPEED = PI * 1.5
@export var ZOOM_MIN = 0.1
@export var ZOOM_MAX = 7.0

var events = {}
var last_drag_distance = 0
var zoom_sensitivity = 10
#var zooming_now : bool = false


func _ready():
	zoom = Vector2(global.zoom_factor, global.zoom_factor)

func _process(delta) -> void:
	zoom_camera(delta)

func _input(event : InputEvent, delta = get_process_delta_time()) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			match event.button_index:
				MOUSE_BUTTON_WHEEL_DOWN:
					global.zoom_factor -= ZOOM_SPEED * delta * global.zoom_factor
				MOUSE_BUTTON_WHEEL_UP:
					global.zoom_factor += ZOOM_SPEED * delta * global.zoom_factor
	
	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			pass
			#zooming_now = false
			#get_node("/root/LevelRestart/LevelTemplate4/Camera2D/CanvasLayer/Label").text = "Drag detected."
		elif events.size() == 2:
			var drag_distance = events[0].position.distance_to(events[1].position)
			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
				var new_zoom = (1 - ZOOM_SPEED * delta) if drag_distance < last_drag_distance else (1 + ZOOM_SPEED * delta)
				global.zoom_factor = clamp(global.zoom_factor * new_zoom, ZOOM_MIN, ZOOM_MAX)
				#zoom = Vector2.ONE * new_zoom
			last_drag_distance = drag_distance
			#get_node("/root/LevelRestart/LevelTemplate4/Camera2D/CanvasLayer/Label").text = str(drag_distance)
			events = {}
			#zooming_now = true


func zoom_camera(delta):
	global.zoom_factor = min(ZOOM_MAX, global.zoom_factor)
	global.zoom_factor = max(ZOOM_MIN, global.zoom_factor)
	zoom.x = lerp(zoom.x, global.zoom_factor, delta * 10)
	zoom.y = lerp(zoom.y, global.zoom_factor, delta * 10)
	#$background.scale *= Vector2(global.zoom_factor, global.zoom_factor)
