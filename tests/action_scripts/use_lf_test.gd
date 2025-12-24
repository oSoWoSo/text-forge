# GdUnit generated TestSuite
class_name UseLFTestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://action_scripts/use_lf.gd'

var use_lf_script: ActionScript
var test_menu: PopupMenu
var test_section := "edit"

var test_initialize_connects_to_settings_changed__signal_received := false

func before_test() -> void:
	# Setup test menu
	test_menu = auto_free(PopupMenu.new())
	test_menu.add_item("Use LF", 100)
	add_child(test_menu)

	use_lf_script = auto_free(load(__source).new())
	use_lf_script.id = 100
	use_lf_script.menu = test_menu

func after_test() -> void:
	if use_lf_script and Signals.settings_changed.is_connected(use_lf_script._load_config):
		Signals.settings_changed.disconnect(use_lf_script._load_config)

func test_char_constant_is_lf() -> void:
	assert_str(use_lf_script.CHAR).is_equal("\n")

func test_initialize_connects_to_settings_changed() -> void:
	use_lf_script._initialize()
	var connections := Signals.settings_changed.get_connections()
	var found := false
	for conn in connections:
		if conn["callable"] == use_lf_script._load_config:
			found = true
			break
	assert_bool(found).is_true()

func test_initialize_calls_load_config() -> void:
	Settings.set_setting(test_section, "line_endings", "LF")
	use_lf_script._initialize()
	# Check menu item is checked after initialization
	assert_bool(test_menu.is_item_checked(test_menu.get_item_index(100))).is_true()

func test_run_action_sets_lf_when_not_current() -> void:
	Settings.set_setting(test_section, "line_endings", "CRLF")
	use_lf_script._run_action()
	assert_str(Settings.get_setting(test_section, "line_endings")).is_equal("LF")

func test_run_action_does_nothing_when_already_lf() -> void:
	Settings.set_setting(test_section, "line_endings", "LF")
	use_lf_script._run_action()
	assert_str(Settings.get_setting(test_section, "line_endings")).is_equal("LF")

func test_load_config_checks_menu_item_when_lf() -> void:
	Settings.set_setting(test_section, "line_endings", "LF")
	use_lf_script._load_config()
	assert_bool(test_menu.is_item_checked(test_menu.get_item_index(100))).is_true()

func test_load_config_unchecks_menu_item_when_not_lf() -> void:
	Settings.set_setting(test_section, "line_endings", "CRLF")
	use_lf_script._load_config()
	assert_bool(test_menu.is_item_checked(test_menu.get_item_index(100))).is_false()

func test_get_value_returns_true_when_lf() -> void:
	Settings.set_setting(test_section, "line_endings", "LF")
	assert_bool(use_lf_script._get_value()).is_true()

func test_get_value_returns_false_when_crlf() -> void:
	Settings.set_setting(test_section, "line_endings", "CRLF")
	assert_bool(use_lf_script._get_value()).is_false()

func test_get_value_returns_false_when_cr() -> void:
	Settings.set_setting(test_section, "line_endings", "CR")
	assert_bool(use_lf_script._get_value()).is_false()

func test_check_option_extra_returns_normalize_setting() -> void:
	Settings.set_setting(test_section, "normalize_line_endings", true)
	assert_bool(use_lf_script._check_option_extra()).is_true()

	Settings.set_setting(test_section, "normalize_line_endings", false)
	assert_bool(use_lf_script._check_option_extra()).is_false()

func test_extends_action_script() -> void:
	assert_object(use_lf_script).is_instanceof(ActionScript)
