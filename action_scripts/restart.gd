extends ActionScript

func _run_action():
	if Global.has_unsaved_change():
		Signals.save_request.emit(id)
		return
	OS.shell_open(OS.get_executable_path())
	get_window().close_requested.emit()
