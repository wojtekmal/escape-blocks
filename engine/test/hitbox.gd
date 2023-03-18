extends	Node2D
class_name hitbox
var vertical := [0, 0]
var horizontal := [0, 0]

var _frame
@export var debug := false

func set_hitbox():
	if get_child_count() < 2:
		return true
	var a = get_child(0)
	var b = get_child(1)
	vertical[0] = min(b.position.x, a.position.x)
	vertical[1] = max(a.position.x, b.position.x)
	horizontal[0] = min(b.position.y, a.position.y)
	horizontal[1] = max(a.position.y, b.position.y)
	if debug:
		_frame = Panel.new()
		_frame.z_index = 1
		_frame.position = Vector2(vertical[0], horizontal[0])
		_frame.size = Vector2(
			abs(vertical[1] - vertical[0]), 
			abs(horizontal[1] - horizontal[0]), 
		)
		add_child(_frame)
	return true

func _ready():
	add_to_group("hitboxes")
	set_hitbox()

func is_colliding_with(hb : Object) -> bool:
#	var l1 = Vector2(
#		vertical[0] + global_position.x,
#		horizontal[0] + global_position.y,
#	)
#	var r1 = Vector2(
#		vertical[1] + global_position.x,
#		horizontal[1] + global_position.y,
#	)
#	var l2 = Vector2(
#		hb.vertical[0] + hb.global_position.x,
#		hb.horizontal[0] + hb.global_position.y,
#	)
#	var r2 = Vector2(
#		hb.vertical[1] + hb.global_position.x,
#		hb.horizontal[1] + hb.global_position.y,
#	)
	
#	if r1.y < l2.y or r2.y < l1.y:
#		return false
#
#	if l1.x > r2.x or l2.x > r1.x:
#		return false
	if horizontal[1] + global_position.y < hb.horizontal[0] + hb.global_position.y or hb.horizontal[1] + hb.global_position.y < horizontal[0] + global_position.y:
		return false
	
	if vertical[0] + global_position.x > hb.vertical[1] + hb.global_position.x or hb.vertical[0] + hb.global_position.x > vertical[1] + global_position.x:
		return false
 
	return true
