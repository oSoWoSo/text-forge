extends PopupPanel

@export var insert: Button
@export var replace: LineEdit
@export var next: Button
@export var previous: Button
@export var close: Button

var regex := RegEx.new()
var result: Array[RegExMatch] = []
var i: int = 0

func start(pattern: String, reset := true) -> void:
	regex = RegEx.create_from_string(pattern)
	result = regex.search_all(Global.get_editor_text())
	if reset:
		i = -1
	if result:
		_on_next_pressed()
	else:
		_on_close_pressed()

func _on_replace_text_submitted(new_text: String) -> void:
	Global.set_editor_text(regex.sub(Global.get_editor_text(), new_text, false, result[i].get_start()))
	i -= 1
	start(regex.get_pattern(), false)


func _on_next_pressed() -> void:
	i = clampi(i + 1, 0, result.size() - 1)
	var _start := Global.get_editor().search(result[i].get_string(), CodeEdit.SearchFlags.SEARCH_MATCH_CASE, 0, 0)
	Global.get_editor().select(_start.y, _start.x, _start.y, _start.x + result[i].get_string().length())
	await U.wait()
	_show_popup()


func _on_previous_pressed() -> void:
	i = clampi(i - 1, 0, result.size() - 1)
	if 0 <= i:
		var _start := Global.get_editor().search(result[i].get_string(), CodeEdit.SearchFlags.SEARCH_MATCH_CASE, 0, 0)
		Global.get_editor().select(_start.y, _start.x, _start.y, _start.x + result[i].get_string().length())
		await U.wait()
		_show_popup()


func _show_popup() -> void:
	if Global.get_editor().get_selected_text(0) in ["{{{!file_name}}}", "{{{!file_path}}}", "{{{!date}}}", "{{{!time}}}", "{{{!datetime}}}"]:
		insert.show()
	else:
		insert.hide()
	match Global.get_editor().get_selected_text(0).replace("{{{", "").replace("}}}", ""):
		"!file_path":
			if Global.has_file():
				insert.tooltip_text = "Auto Insert\nYou can insert file path in one click."
				insert.disabled = false
			else:
				insert.tooltip_text = "Auto Insert\nThis file ins't saved yet!"
				insert.disabled = true
		"!file_name":
			if Global.has_file():
				insert.tooltip_text = "Auto Insert\nYou can insert file name in one click."
				insert.disabled = false
			else:
				insert.tooltip_text = "Auto Insert\nThis file ins't saved yet!"
				insert.disabled = true
		"!date":
			insert.tooltip_text = "Auto Insert\nYou can insert current date as YYYY-MM-DD in one click."
			insert.disabled = false
		"!time":
			insert.tooltip_text = "Auto Insert\nYou can insert current time as HH:MM:SS in one click."
			insert.disabled = false
		"!datetime":
			insert.tooltip_text = "Auto Insert\nYou can insert current date and time as YYYY-MM-DD HH:MM:SS in one click."
			insert.disabled = false
		_:
			insert.tooltip_text = "Auto Insert\nThis feature isn't available for this placeholder!"
			insert.disabled = true
	popup(Rect2i(Global.get_editor().get_caret_draw_pos() + Global.get_editor().global_position + Vector2(get_tree().get_root().position) + Vector2(0, Settings.get_setting("editor_ui", "font_size")), size))
	replace.grab_focus()
	replace.select_all()


func _on_close_pressed() -> void:
	Global.get_editor().deselect()
	hide()


func _on_insert_pressed() -> void:
	var text := ""
	match Global.get_editor().get_selected_text(0).replace("{{{", "").replace("}}}", ""):
		"!file_path":
			text = Global.get_file_path()
		"!file_name":
			text = Global.get_file_name()
		"!date":
			text = Time.get_date_string_from_system()
		"!time":
			text = Time.get_time_string_from_system()
		"!datetime":
			text = Time.get_datetime_string_from_system(false, true)
	_on_replace_text_submitted(text)
