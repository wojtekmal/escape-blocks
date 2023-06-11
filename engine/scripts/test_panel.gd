extends MarginContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	queue_sort()
	print($MyPanel.size)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print($MyPanel.size)
