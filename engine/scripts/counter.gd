extends CanvasLayer

@onready var text = $Counter/RichTextLabel

func _ready():
	if global.is_mobile():
		$Counter/RichTextLabel.label_settings.font_size = 60

func _process(delta):
	if !global.is_mobile() && global.settings["show_hint"]:
		$Counter/RichTextLabel2.visible = true
	else:
		$Counter/RichTextLabel2.visible = false

func update(number := 0):
	if number == 1:
		text.text = str(number) + " rotation"
	else:
		text.text = str(number) + " rotations"

func manage_phone_rotation():
	global.control_manage_phone_rotation($Counter)
