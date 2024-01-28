extends AudioStreamPlayer

var music_list := [
	preload("res://sound/escapeblocksv5.mp3"),
	preload("res://sound/happy_moon_02.mp3"),
	preload("res://sound/happy_moon_1+2+3.mp3"),
]

var music_list_files := [
	"Audio/escapeblocksv5.mp3",
	"Audio/happy_moon_02.mp3",
	"Audio/happy_moon_1+2+3.mp3",
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
	if OS.get_name() != "Web":
		play()
		return
	
	## top dictionary
	#var arg = JavaScriptBridge.create_object("Array", 0)
		#
	## src array
	#arg["src"] = JavaScriptBridge.create_object("Array", 1)
	#arg["src"][0] = music_list_files.pick_random()
	#
	## Howl obj
	#var obj = JavaScriptBridge.create_object("Howl", arg)
	#obj.play()
	#
	## using JavaScriptBridge.eval is not recommended since most of online platforms doesn't have eval enabled and might consider it a security risk
