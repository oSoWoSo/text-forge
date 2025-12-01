class_name ColorPickerWindow
extends Window
## A helper window to work with colors.

## [ColorPicker] node.
@export var color_picker: ColorPicker

func _ready() -> void:
	color_picker.resized.connect(func(): size = color_picker.size)
