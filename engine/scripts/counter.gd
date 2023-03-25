extends Control

@onready var text = $CanvasLayer/RichTextLabel

func update(number := 0):
	if number == 1:
		text.text = str(number) + " rotation"
	else:
		text.text = str(number) + " rotations"
