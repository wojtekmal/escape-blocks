extends CanvasLayer

@onready var text = $Counter/RichTextLabel

func update(number := 0):
	if number == 1:
		text.text = str(number) + " rotation"
	else:
		text.text = str(number) + " rotations"

func manage_phone_rotation():
	global.control_manage_phone_rotation($Counter)
