extends ActionScript

func _run_action() -> void:
	if Global.has_unsaved_change():
		Signals.save_request.emit(id)
		return
	var err := OS.shell_open(OS.get_executable_path())
	if err:
		Global.send_notification(
			Global.Notification.ERROR,
			"Failed to run editor again!",
			"Error code: " + str(err)
		)
	else:
		get_window().close_requested.emit()
