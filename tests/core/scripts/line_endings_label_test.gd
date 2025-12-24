# GdUnit generated TestSuite
class_name LineEndingsLabelTestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://core/scripts/line_endings_label.gd'

var line_endings_label: LineEndings
var test_section := "edit"

func before_test() -> void:
	# Clean up test settings
	if Settings.settings.has_section(test_section):
		Settings.settings.erase_section(test_section)
	if Settings.presets.has_section(test_section):
		Settings.presets.erase_section(test_section)

	# Initialize default settings
	Settings.define_preset(test_section, "normalize_line_endings", true)
	Settings.define_preset(test_section, "line_endings", "LF")

	line_endings_label = auto_free(LineEndings.new())
	add_child(line_endings_label)
	Global.set_editor_text("", false)

func after_test() -> void:
	# Clean up test settings
	if Settings.settings.has_section(test_section):
		Settings.settings.erase_section(test_section)
	if Settings.presets.has_section(test_section):
		Settings.presets.erase_section(test_section)

func test_extends_menu_button() -> void:
	assert_object(line_endings_label).is_instanceof(MenuButton)

func test_ready_connects_to_type_timer() -> void:
	await get_tree().process_frame
	var connections := Global.get_editor().type_timer_timeout.get_connections()
	var found := false
	for conn in connections:
		if conn["callable"].get_object() == line_endings_label:
			found = true
			break
	assert_bool(found).is_true()

func test_ready_connects_to_settings_changed() -> void:
	await get_tree().process_frame
	var connections := Signals.settings_changed.get_connections()
	var found := false
	for conn in connections:
		if conn["callable"] == line_endings_label._update_label:
			found = true
			break
	assert_bool(found).is_true()

func test_ready_connects_to_popup_id_pressed() -> void:
	await get_tree().process_frame
	var popup := line_endings_label.get_popup()
	var connections := popup.id_pressed.get_connections()
	var found := false
	for conn in connections:
		if conn["callable"] == line_endings_label._on_id_pressed:
			found = true
			break
	assert_bool(found).is_true()

func test_update_label_shows_lf_when_normalized() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", true)
	Settings.set_setting(test_section, "line_endings", "LF")
	line_endings_label._update_label()
	assert_str(line_endings_label.text).is_equal("LF")

func test_update_label_shows_crlf_when_normalized() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", true)
	Settings.set_setting(test_section, "line_endings", "CRLF")
	line_endings_label._update_label()
	assert_str(line_endings_label.text).is_equal("CRLF")

func test_update_label_shows_cr_when_normalized() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", true)
	Settings.set_setting(test_section, "line_endings", "CR")
	line_endings_label._update_label()
	assert_str(line_endings_label.text).is_equal("CR")

func test_update_label_adds_asterisk_when_not_normalized() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", false)
	Settings.set_setting(test_section, "line_endings", "LF")
	Global.set_editor_text("test", true)
	line_endings_label._update_label()
	assert_bool(line_endings_label.text.contains("*")).is_true()

func test_update_label_no_asterisk_when_normalized() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", true)
	Settings.set_setting(test_section, "line_endings", "LF")
	line_endings_label._update_label()
	assert_bool(line_endings_label.text.contains("*")).is_false()

func test_update_label_tooltip_shows_disabled_message() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", false)
	line_endings_label._update_label()
	assert_bool(line_endings_label.tooltip_text.contains("disabled")).is_true()

func test_update_label_tooltip_no_disabled_message_when_enabled() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", true)
	line_endings_label._update_label()
	assert_bool(line_endings_label.tooltip_text.contains("disabled")).is_false()

func test_eol_to_updates_setting() -> void:
	line_endings_label._eol_to("\r\n")
	assert_str(Settings.get_setting(test_section, "line_endings")).is_equal("CRLF")

func test_eol_to_handles_empty_text() -> void:
	Global.set_editor_text("", true)
	line_endings_label._eol_to("\n")
	var result := Global.get_editor_text()
	assert_str(result).is_equal("")

func test_update_label_handles_empty_text() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", false)
	Global.set_editor_text("", true)
	line_endings_label._update_label()
	# With no line endings, should default to LF
	assert_str(line_endings_label.text).is_equal("LF*")
