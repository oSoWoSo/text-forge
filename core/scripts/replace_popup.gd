class_name ReplacePopup
extends PopupPanel
## An advanced [PopupPanel] for intractive replace in templates.

## Keeps available options for auto-insert.
const AUTO_INSERT_OPTIONS = {
	FILE_NAME = "{{{!file_name}}}",
	FILE_PATH = "{{{!file_path}}}",
	DATE = "{{{!date}}}",
	TIME = "{{{!time}}}",
	DATE_TIME = "{{{!datetime}}}",
}

## Auto-insert button.
@export var insert: Button
## Replace value.
@export var replace: LineEdit
## Next button.
@export var next: Button
## Previous button.
@export var previous: Button
## Close popup button.
@export var close: Button

## [Regex] to find and replace patterns.
var regex: RegEx
## Matches for RegEx search.
var result: Array[RegExMatch] = []
## Index of current match.
var i: int = 0

## Continiues a search recursivly.
func start(pattern: String, reset := true) -> void:
	regex = RegEx.new()
	if regex.compile(pattern):
		hide()
		return
	result = regex.search_all(Global.get_editor_text())
	if reset:
		i = -1
	if result.is_empty():
		_on_close_pressed()
		return
	_on_next_pressed()


## Replace current match and keep here (because matches will shift to behind).
func _on_replace_text_submitted(new_text: String) -> void:
	Global.set_editor_text(regex.sub(Global.get_editor_text(), new_text, false, result[i].get_start()))
	i -= 1
	start(regex.get_pattern(), false)


## Select next match and show popup.
func _on_next_pressed() -> void:
	i = clampi(i + 1, 0, result.size() - 1)
	var _start := Global.get_editor().search(result[i].get_string(), CodeEdit.SearchFlags.SEARCH_MATCH_CASE, 0, 0)
	Global.get_editor().select(_start.y, _start.x, _start.y, _start.x + result[i].get_string().length())
	await U.wait()
	_show_popup()


## Select previous match and show popup.
func _on_previous_pressed() -> void:
	i = clampi(i - 1, 0, result.size() - 1)
	var _start := Global.get_editor().search(result[i].get_string(), CodeEdit.SearchFlags.SEARCH_MATCH_CASE, 0, 0)
	Global.get_editor().select(_start.y, _start.x, _start.y, _start.x + result[i].get_string().length())
	await U.wait()
	_show_popup()


## Show popup with optional auto-insert.
func _show_popup() -> void:
	if Global.get_editor().get_selected_text(0) in AUTO_INSERT_OPTIONS.values():
		insert.show()
	else:
		insert.hide()
	match Global.get_editor().get_selected_text(0):
		AUTO_INSERT_OPTIONS.FILE_PATH:
			if Global.has_file():
				insert.tooltip_text = "Auto Insert\nYou can insert file path in one click."
				insert.disabled = false
			else:
				insert.tooltip_text = "Auto Insert\nThis file isn't saved yet!"
				insert.disabled = true
		AUTO_INSERT_OPTIONS.FILE_NAME:
			if Global.has_file():
				insert.tooltip_text = "Auto Insert\nYou can insert file name in one click."
				insert.disabled = false
			else:
				insert.tooltip_text = "Auto Insert\nThis file isn't saved yet!"
				insert.disabled = true
		AUTO_INSERT_OPTIONS.DATE:
			insert.tooltip_text = "Auto Insert\nYou can insert current date as YYYY-MM-DD in one click."
			insert.disabled = false
		AUTO_INSERT_OPTIONS.TIME:
			insert.tooltip_text = "Auto Insert\nYou can insert current time as HH:MM:SS in one click."
			insert.disabled = false
		AUTO_INSERT_OPTIONS.DATE_TIME:
			insert.tooltip_text = "Auto Insert\nYou can insert current date and time as YYYY-MM-DD HH:MM:SS in one click."
			insert.disabled = false
		_:
			insert.tooltip_text = "Auto Insert\nThis feature isn't available for this placeholder!"
			insert.disabled = true
	popup(Rect2i(Global.get_editor().get_caret_global_draw_pos(), size))
	replace.grab_focus()
	replace.select_all()


## Hides popup and deselects match.
func _on_close_pressed() -> void:
	Global.get_editor().deselect()
	hide()


## Inserts automatic generated values.
func _on_insert_pressed() -> void:
	var text := ""
	match Global.get_editor().get_selected_text(0):
		AUTO_INSERT_OPTIONS.FILE_PATH:
			text = Global.get_file_path()
		AUTO_INSERT_OPTIONS.FILE_NAME:
			text = Global.get_file_name()
		AUTO_INSERT_OPTIONS.DATE:
			text = Time.get_date_string_from_system()
		AUTO_INSERT_OPTIONS.TIME:
			text = Time.get_time_string_from_system()
		AUTO_INSERT_OPTIONS.DATE_TIME:
			text = Time.get_datetime_string_from_system(false, true)
	_on_replace_text_submitted(text)
