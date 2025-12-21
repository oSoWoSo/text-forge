extends CheckableActionScript

func _setup() -> void:
	settings_section = "edit"
	settings_key = "remove_trailing_whitespaces"
	default = true
	Global.get_editor_api().connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, _normalizer)


func _get_value() -> bool:
	return Settings.get_setting(settings_section, settings_key)


func _normalizer() -> void:
	if not _get_value():
		return
	# Uses temporary editor to keep line endings.
	var temp_editor := TextEdit.new()
	temp_editor.set_text(Global.get_editor_text())
	for l in temp_editor.get_line_count():
		temp_editor.set_line(l, temp_editor.get_line(l).strip_edges(false, true))
	Global.set_editor_text(temp_editor.get_text())
	temp_editor.queue_free()
