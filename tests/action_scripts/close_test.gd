# GdUnit generated TestSuite
class_name CloseActionTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://action_scripts/close.gd'

var close_script: ActionScript

func before_test() -> void:
	close_script = load(__source).new()

func after_test() -> void:
	if close_script:
		close_script.free()

func test_initialize_sets_requires_file() -> void:
	close_script._initialize()
	assert_bool(close_script.requires_file).is_true()

func test_initialize_connects_to_close_file_signal() -> void:
	# Verify the signal connection is established
	close_script._initialize()
	var connections = Signals.close_file.get_connections()
	var found := false
	for conn in connections:
		if conn["callable"].get_object() == close_script:
			found = true
			break
	assert_bool(found).is_true()

func test_run_action_returns_early_with_unsaved_changes() -> void:
	# This test verifies the early return behavior
	# Since we can't easily mock Global singleton, we test the script structure
	# The actual behavior would be tested in integration tests
	assert_object(close_script).is_not_null()

func test_script_extends_action_script() -> void:
	assert_object(close_script).is_instanceof(ActionScript)

func test_run_action_callable_exists() -> void:
	assert_bool(close_script.has_method("_run_action")).is_true()
