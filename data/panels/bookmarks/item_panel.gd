extends PanelContainer

@export var number_label: Label
@export var line_label: Label
@export var goto_button: Button
@export var remove_button: Button

var _line: int:
	set(value):
		_line = value
		number_label.text = str(value + 1)

func update(line_text: String, line: int) -> void:
	line_label.text = line_text
	line_label.tooltip_text = line_text
	_line = line


func _on_go_to_pressed() -> void:
	Global.get_editor().set_caret_line(_line, true, false)
	Global.get_editor().grab_focus()


func _on_remove_pressed() -> void:
	Global.get_editor().set_line_as_bookmarked(_line, false)
	if not Global.has_unsaved_change():
		Global.set_file_name(Global.get_file_name() + "*")
	hide()
