extends Window

@export var input: LineEdit
@export var submit: Button

func _ready() -> void:
	submit.pressed.connect(close_requested.emit)
	input.text_submitted.connect(close_requested.emit.unbind(1))
