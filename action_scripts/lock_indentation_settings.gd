extends CheckableActionScript

func _setup() -> void:
	settings_section = "edit"
	settings_key = "lock_indentation_settings"
	default = false


func _get_value() -> bool:
	return Settings.get_setting(settings_section, settings_key)
