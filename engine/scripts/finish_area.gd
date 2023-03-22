@tool
extends Area2D
signal player_reached_finish
@export var intitial_rotations : int

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
