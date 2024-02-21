extends CanvasLayer

var _time := 0.0
var timer_on := false

func stop(value := true):
	timer_on = not value

func _physics_process(delta):
	if timer_on:
		_time += delta
	var ms = fmod(_time, 1) * 100
	var sec = roundf(_time)
#	$RichTextLabel.text =  str(sec) + ":" + str(ms)
	
	$Control/RichTextLabel.text =  "\n%d.%02d s" % [sec, ms]
	$Control/RichTextLabel.text += "\n" + str(Engine.get_frames_per_second())  + "fps"
