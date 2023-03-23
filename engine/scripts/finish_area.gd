@tool
class_name FinishArea
extends Area2D
signal player_reached_finish
@export var initial_rotations : int : set = set_intitial_rotations

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var overlapping_entities = get_overlapping_bodies()
	
	for entity in overlapping_entities:
		if entity.get_name() == "Player":
			emit_signal("player_reached_finish")
			#print_debug("player_reached_finish")

func set_intitial_rotations(newValue):
	initial_rotations = newValue
	rotation = initial_rotations * PI / 2
