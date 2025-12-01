extends ActionScript

func _initialize() -> void:
	requires_file = true


func _run_action() -> void:
	if Global.get_editor().get_caret_count() > 1:
		Global.send_notification(Global.Notification.WARNING, "Evaluate selection only supports main caret!")
	var expression := Expression.new()
	var error := expression.parse(Global.get_editor().get_selected_text(0))
	if error:
		Global.send_notification(Global.Notification.ERROR, "Failed to parse expression!")
		return
	var result = expression.execute([], self)
	if expression.has_execute_failed():
		Global.send_notification(Global.Notification.ERROR, "Failed to execute expression!")
		return
	var selection := Vector2i(Global.get_editor().get_selection_origin_line(), Global.get_editor().get_selection_origin_column())
	var caret := Vector2i(Global.get_editor().get_caret_line(), Global.get_editor().get_caret_column())
	var editor_text := Global.get_editor_text()
	var selection_idx := Global.get_editor().get_char_index(selection.x, selection.y)
	var caret_idx := Global.get_editor().get_char_index(caret.x, caret.y)
	var start_idx := mini(selection_idx, caret_idx)
	var end_idx := maxi(selection_idx, caret_idx)
	Global.set_editor_text(editor_text.substr(0, start_idx) + str(result) + editor_text.substr(end_idx))
	var result_str := str(result)
	var start_pos := Vector2i(selection.x, selection.y) if selection_idx < caret_idx else Vector2i(caret.x, caret.y)
	var result_lines := result_str.split("\n")
	var end_line := start_pos.x + result_lines.size() - 1
	var end_column := result_lines[-1].length() if result_lines.size() > 1 else start_pos.y + result_str.length()
	Global.get_editor().select(start_pos.x, start_pos.y, end_line, end_column)
