extends ActionScript

const SAVE_CHAR = "CR"
const CHAR = "\r"

func _initialize() -> void:
	Signals.settings_changed.connect(_load_config)
	_load_config()


func _run_action() -> void:
	if not _get_value():
		Settings.set_setting("edit", "line_endings", SAVE_CHAR)


func _load_config() -> void:
	menu.set_item_checked(menu.get_item_index(id), _get_value())


func _check_option_extra() -> bool:
	return Settings.get_setting("edit", "normalize_line_endings")


func _get_value() -> bool:
	return Settings.get_setting("edit", "line_endings") == SAVE_CHAR
