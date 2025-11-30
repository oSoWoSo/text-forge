extends ActionScript

func _initialize() -> void:
	requires_file = true

func _run_action() -> void:
	if Global.get_editor().delimiter_comments.size() == 0:
		Global.send_notification(
			Global.Notification.ERROR,
			"There is no comment delimiter!",
			"Please select a mode with comment delimiter."
		)
		return
	Global.get_editor().begin_complex_operation()
	Global.get_editor().begin_multicaret_edit()
	var start_key := Global.get_editor().get_delimiter_start_key(0)
	var end_key := Global.get_editor().get_delimiter_end_key(0)
	var text := Global.get_editor_text().split("\n")
	for caret in Global.get_editor().get_caret_count():
		var line := Global.get_editor().get_caret_line(caret)
		var column := Global.get_editor().get_caret_column(caret)
		var delimiter_start := Global.get_editor().get_delimiter_start_position(line, column)
		var delimiter_end := Global.get_editor().get_delimiter_end_position(line, column)
		if delimiter_start == Vector2(-1, -1) or delimiter_end == Vector2(-1, -1):
			var insert_pos := text[line].length() - text[line].strip_edges(true, false).length()
			text[line] = text[line].insert(insert_pos, start_key)
			if end_key:
				text[line] += end_key
		else:
			text[delimiter_start.y] = text[delimiter_start.y].erase(delimiter_start.x, start_key.length())
			text[delimiter_end.y] = text[delimiter_end.y].erase(delimiter_end.x - end_key.length(), end_key.length())
	Global.set_editor_text("\n".join(text))
	Global.get_editor().end_multicaret_edit()
	Global.get_editor().end_complex_operation()
	Global.get_editor().text_changed.emit()
