extends ActionScript

func _initialize() -> void:
	requires_file = true


func _run_action() -> void:
	if Global.get_editor().get_bookmarked_lines().is_empty():
		return
	Global.get_editor().clear_bookmarked_lines()
	Global.get_editor().type_timer_timeout.emit()
	if not Global.has_unsaved_change():
		Global.set_file_name(Global.get_file_name() + "*")
