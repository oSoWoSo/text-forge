extends ActionScript

func _check_option_extra() -> bool:
	return Global.get_editor_api().current_mode.has("id")


func _run_action() -> void:
	Global.get_editor_api().reset_to_mode_indentation_settings()
