# GdUnit generated TestSuite
class_name EditorAPIHooksTestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://core/scripts/editor_api.gd'

var editor_api: EditorAPI

var test_connect_to_hook_stores_callable__hook_called := false
var test_run_hook_executes_connected_callables__hook1_called := false
var test_run_hook_executes_connected_callables__hook2_called := false
var test_run_hook_with_multiple_hooks__call_count := 0
var test_disconnect_removes_callable__hook_called := false
var test_run_hook_continues_after_error__hook2_called := false
var test_hooks_integration_with_save_file__hook_executed := false

func before_test() -> void:
	editor_api = auto_free(EditorAPI.new())
	add_child(editor_api)

func after_test() -> void:
	# Clean up all hooks
	if editor_api:
		editor_api.hooks.clear()

func test_hooks_enum_exists() -> void:
	assert_bool(EditorAPI.Hooks.has("BEFORE_SAVE")).is_true()

func test_hooks_enum_before_save_value() -> void:
	assert_int(EditorAPI.Hooks.BEFORE_SAVE).is_equal(0)

func test_hooks_dictionary_initialized() -> void:
	assert_object(editor_api.hooks).is_not_null()
	assert_bool(typeof(editor_api.hooks) == TYPE_DICTIONARY).is_true()

func test_connect_to_hook_creates_hook_array() -> void:
	var callable := func(): pass
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	assert_bool(editor_api.hooks.has(EditorAPI.Hooks.BEFORE_SAVE)).is_true()
	assert_bool(typeof(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE]) == TYPE_ARRAY).is_true()

func test_connect_to_hook_stores_callable() -> void:
	var callable := func(): test_connect_to_hook_stores_callable__hook_called = true
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	assert_int(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].size()).is_equal(1)
	assert_bool(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].has(callable)).is_true()

func test_connect_to_hook_multiple_callables() -> void:
	var callable1 := func(): pass
	var callable2 := func(): pass
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable1)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable2)
	assert_int(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].size()).is_equal(2)

func test_connect_to_hook_prevents_duplicate_callables() -> void:
	var callable := func(): pass
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	assert_int(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].size()).is_equal(1)

func test_connect_to_hook_allows_same_callable_different_args() -> void:
	var base_callable := func(x): pass
	var callable1 := base_callable.bind(1)
	var callable2 := base_callable.bind(2)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable1)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable2)
	assert_int(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].size()).is_equal(2)

func test_disconnect_from_hook_removes_callable() -> void:
	var callable := func(): pass
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	editor_api.disconnect_from_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	assert_int(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].size()).is_equal(0)

func test_disconnect_from_hook_handles_non_existent_hook() -> void:
	var callable := func(): pass
	# Should not crash
	editor_api.disconnect_from_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	assert_bool(true).is_true()

func test_disconnect_from_hook_handles_non_existent_callable() -> void:
	var callable1 := func(): pass
	var callable2 := func(): pass
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable1)
	editor_api.disconnect_from_hook(EditorAPI.Hooks.BEFORE_SAVE, callable2)
	assert_int(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].size()).is_equal(1)

func test_run_hook_executes_connected_callables() -> void:
	var callable1 := func(): test_run_hook_executes_connected_callables__hook1_called = true
	var callable2 := func(): test_run_hook_executes_connected_callables__hook2_called = true
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable1)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable2)

	editor_api._run_hook(EditorAPI.Hooks.BEFORE_SAVE)

	assert_bool(test_run_hook_executes_connected_callables__hook1_called).is_true()
	assert_bool(test_run_hook_executes_connected_callables__hook2_called).is_true()

func test_run_hook_handles_non_existent_hook() -> void:
	# Should not crash
	editor_api._run_hook(EditorAPI.Hooks.BEFORE_SAVE)
	assert_bool(true).is_true()

func test_run_hook_handles_empty_hook_array() -> void:
	editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE] = []
	# Should not crash
	editor_api._run_hook(EditorAPI.Hooks.BEFORE_SAVE)
	assert_bool(true).is_true()

func test_run_hook_with_callable_arguments() -> void:
	var result := [0]
	var callable := func(arr): arr[0] = 42
	var bound_callable := callable.bind(result)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, bound_callable)

	editor_api._run_hook(EditorAPI.Hooks.BEFORE_SAVE)

	assert_int(result[0]).is_equal(42)

func test_run_hook_disconnects_invalid_callables() -> void:
	var obj := Node.new()
	var callable := Callable(obj, "some_method")
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)
	obj.free()

	await get_tree().process_frame

	editor_api._run_hook(EditorAPI.Hooks.BEFORE_SAVE)
	await get_tree().process_frame

	# Invalid callable should be removed
	assert_int(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].size()).is_equal(0)

func test_run_hook_execution_order_preserved() -> void:
	var execution_order := []
	var callable1 := func(): execution_order.append(1)
	var callable2 := func(): execution_order.append(2)
	var callable3 := func(): execution_order.append(3)

	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable1)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable2)
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable3)

	editor_api._run_hook(EditorAPI.Hooks.BEFORE_SAVE)

	assert_array(execution_order).is_equal([1, 2, 3])

func test_hooks_integration_with_save_file() -> void:
	var callable := func(): test_hooks_integration_with_save_file__hook_executed = true
	editor_api.connect_to_hook(EditorAPI.Hooks.BEFORE_SAVE, callable)

	# Note: Full save_file test would require extensive mocking
	# This test verifies the hook mechanism is accessible
	assert_bool(editor_api.hooks.has(EditorAPI.Hooks.BEFORE_SAVE)).is_true()
	assert_bool(editor_api.hooks[EditorAPI.Hooks.BEFORE_SAVE].has(callable)).is_true()
