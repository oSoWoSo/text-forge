extends MenuButton

func _ready() -> void:
	Global.get_editor_api().indentation_settings_updated.connect(_update_label)
	get_popup().id_pressed.connect(_on_id_pressed)


func _update_label(use_spaces: bool, indent_size: int) -> void:
	text = ("Spaces" if use_spaces else "Tabs") + " (" + str(indent_size) + ")"


func _on_id_pressed(id: int) -> void:
	match id:
		0: # Indent with spaces
			Global.get_editor_api().change_indentation_type(true)
		1: # Indent with tabs
			Global.get_editor_api().change_indentation_type(false)
		2: # Edit indent size
			add_child(Factory.single_line_input("Indent Size", "Set", change_indent_size, true))


func change_indent_size(value: String) -> void:
	Global.get_editor_api().change_indent_size(max(int(value), 1))
