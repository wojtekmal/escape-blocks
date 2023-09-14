extends AudioStreamPlayer

var music_list := [
	preload("res://sound/escapeblocksv5.mp3"),
	preload("res://sound/happy_moon_02.mp3"),
	preload("res://sound/happy_moon_1+2+3.mp3"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	play_new()
	finished.connect(play_new)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play_new():
	stream = music_list.pick_random()
	play()
