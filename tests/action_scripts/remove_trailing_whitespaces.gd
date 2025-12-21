# GdUnit generated TestSuite
class_name RemoveTrailingWhitespacesTestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://action_scripts/remove_trailing_whitespaces.gd'

var whitespace_script: CheckableActionScript
var test_section := "edit"
var test_key := "remove_trailing_whitespaces"

func before_test() -> void:
	whitespace_script = load(__source).new()
	whitespace_script._setup()

func after_test() -> void:
	if whitespace_script:
		# Disconnect from hook if connected
		var api := Global.get_editor_api()
		if api.hooks.has(EditorAPI.Hooks.BEFORE_SAVE):
			if api.hooks[EditorAPI.Hooks.BEFORE_SAVE].has(whitespace_script._normalizer):
				api.disconnect_from_hook(EditorAPI.Hooks.BEFORE_SAVE, whitespace_script._normalizer)
		whitespace_script.free()

func test_setup_defines_settings_section() -> void:
	assert_str(whitespace_script.settings_section).is_equal("edit")

func test_setup_defines_settings_key() -> void:
	assert_str(whitespace_script.settings_key).is_equal("remove_trailing_whitespaces")

func test_setup_defines_default_value() -> void:
	assert_bool(whitespace_script.default).is_true()

func test_setup_connects_to_before_save_hook() -> void:
	var api := Global.get_editor_api()
	assert_bool(api.hooks.has(EditorAPI.Hooks.BEFORE_SAVE)).is_true()
	assert_bool(api.hooks[EditorAPI.Hooks.BEFORE_SAVE].has(whitespace_script._normalizer)).is_true()

func test_get_value_returns_setting() -> void:
	Settings.set_setting(test_section, test_key, true)
	assert_bool(whitespace_script._get_value()).is_true()

	Settings.set_setting(test_section, test_key, false)
	assert_bool(whitespace_script._get_value()).is_false()

func test_normalizer_removes_trailing_spaces() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("line1   \nline2  \nline3 ", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("line1\nline2\nline3")

func test_normalizer_removes_trailing_tabs() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("line1\t\t\nline2\t\nline3", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("line1\nline2\nline3")

func test_normalizer_removes_mixed_trailing_whitespace() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("line1 \t \nline2\t \t\nline3  \t", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("line1\nline2\nline3")

func test_normalizer_preserves_leading_whitespace() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("  line1  \n\tline2\t\n \tline3 \t", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("  line1\n\tline2\n \tline3")

func test_normalizer_preserves_line_endings_lf() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("line1  \nline2  \nline3  ", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_bool(result.contains("\n")).is_true()
	assert_bool(result.contains("\r\n")).is_false()

func test_normalizer_respects_disabled_setting() -> void:
	Settings.set_setting(test_section, test_key, false)
	var original_text := "line1   \nline2  \nline3 "
	Global.set_editor_text(original_text, true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal(original_text)

func test_normalizer_handles_empty_text() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("")

func test_normalizer_handles_whitespace_only_lines() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("line1\n   \nline2\n\t\t\nline3", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("line1\n\nline2\n\nline3")

func test_normalizer_handles_single_line_with_trailing_whitespace() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("single line   ", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("single line")

func test_normalizer_preserves_internal_whitespace() -> void:
	Settings.set_setting(test_section, test_key, true)
	Global.set_editor_text("word1  word2  word3  \nline2 \t text  ", true)

	whitespace_script._normalizer()

	var result := Global.get_editor_text()
	assert_str(result).is_equal("word1  word2  word3\nline2 \t text")
