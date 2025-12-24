# GdUnit generated TestSuite
class_name UseCRLFTestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://action_scripts/use_crlf.gd'

var use_crlf_script: ActionScript
var test_menu: PopupMenu
var test_section := "edit"

func before_test() -> void:
	# Setup test menu
	test_menu = auto_free(PopupMenu.new())
	test_menu.add_item("Use CRLF", 101)
	add_child(test_menu)

	use_crlf_script = auto_free(load(__source).new())
	use_crlf_script.id = 101
	use_crlf_script.menu = test_menu

func after_test() -> void:
	if use_crlf_script and Signals.settings_changed.is_connected(use_crlf_script._load_config):
		Signals.settings_changed.disconnect(use_crlf_script._load_config)

func test_char_constant_is_crlf() -> void:
	assert_str(use_crlf_script.CHAR).is_equal("\r\n")

func test_initialize_connects_to_settings_changed() -> void:
	use_crlf_script._initialize()
	var connections := Signals.settings_changed.get_connections()
	var found := false
	for conn in connections:
		if conn["callable"] == use_crlf_script._load_config:
			found = true
			break
	assert_bool(found).is_true()

func test_initialize_calls_load_config() -> void:
	Settings.set_setting(test_section, "line_endings", "CRLF")
	use_crlf_script._initialize()
	# Check menu item is checked after initialization
	assert_bool(test_menu.is_item_checked(test_menu.get_item_index(101))).is_true()

func test_run_action_sets_crlf_when_not_current() -> void:
	Settings.set_setting(test_section, "line_endings", "LF")
	use_crlf_script._run_action()
	assert_str(Settings.get_setting(test_section, "line_endings")).is_equal("CRLF")

func test_run_action_does_nothing_when_already_crlf() -> void:
	Settings.set_setting(test_section, "line_endings", "CRLF")
	use_crlf_script._run_action()
	assert_str(Settings.get_setting(test_section, "line_endings")).is_equal("CRLF")

func test_load_config_checks_menu_item_when_crlf() -> void:
	Settings.set_setting(test_section, "line_endings", "CRLF")
	use_crlf_script._load_config()
	assert_bool(test_menu.is_item_checked(test_menu.get_item_index(101))).is_true()

func test_load_config_unchecks_menu_item_when_not_crlf() -> void:
	Settings.set_setting(test_section, "line_endings", "LF")
	use_crlf_script._load_config()
	assert_bool(test_menu.is_item_checked(test_menu.get_item_index(101))).is_false()

func test_get_value_returns_true_when_crlf() -> void:
	Settings.set_setting(test_section, "line_endings", "CRLF")
	assert_bool(use_crlf_script._get_value()).is_true()

func test_get_value_returns_false_when_lf() -> void:
	Settings.set_setting(test_section, "line_endings", "LF")
	assert_bool(use_crlf_script._get_value()).is_false()

func test_get_value_returns_false_when_cr() -> void:
	Settings.set_setting(test_section, "line_endings", "CR")
	assert_bool(use_crlf_script._get_value()).is_false()

func test_check_option_extra_returns_normalize_setting() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", true)
	assert_bool(use_crlf_script._check_option_extra()).is_true()

	Settings.set_setting(test_section, "normalize_line_endings", false)
	assert_bool(use_crlf_script._check_option_extra()).is_false()

func test_extends_action_script() -> void:
	assert_object(use_crlf_script).is_instanceof(ActionScript)
