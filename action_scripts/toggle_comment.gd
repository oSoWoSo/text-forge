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
	var text = Global.get_editor_text().split("\n")
	for caret in Global.get_editor().get_caret_count():
		for line in range(
				Global.get_editor().get_selection_from_line(caret),
				Global.get_editor().get_selection_to_line(caret) + 1
			):
			var comment_pos := Global.get_editor().is_in_comment(line)
			if comment_pos != -1:
				text[line] = text.get(line).erase(
					comment_pos,
					Global.get_editor().get_comment_delimiters()[0].length()
				)
			else:
				text[line] = Global.get_editor().get_comment_delimiters()[0] + text.get(line)
	Global.set_editor_text("\n".join(text))
	Global.get_editor().end_multicaret_edit()
	Global.get_editor().end_complex_operation()
	Global.get_editor().text_changed.emit()
