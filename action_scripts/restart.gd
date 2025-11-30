extends ActionScript

func _run_action() -> void:
	if Global.has_unsaved_change():
		Signals.save_request.emit(id)
		return
	var pid := OS.create_process(OS.get_executable_path(), [])
	if pid != -1:
		get_window().close_requested.emit()
	else:
		Global.send_notification(
			Global.Notification.ERROR,
			"Failed to restart the application"
		)
