# GdUnit generated TestSuite
class_name ActionScriptTestSuite
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://core/classes/action_script.gd'

var test_action_script: ActionScript
var test_menu: PopupMenu

func before_test() -> void:
	test_menu = auto_free(PopupMenu.new())
	test_menu.add_item("Test Action", 100)
	add_child(test_menu)

	test_action_script = auto_free(ActionScript.new())
	test_action_script.id = 100
	test_action_script.menu = test_menu

func test_action_script_initializes() -> void:
	assert_object(test_action_script).is_not_null()
	assert_object(test_action_script).is_instanceof(ActionScript)

func test_id_property_set() -> void:
	assert_int(test_action_script.id).is_equal(100)

func test_menu_property_set() -> void:
	assert_object(test_action_script.menu).is_equal(test_menu)

func test_requires_file_default_false() -> void:
	assert_bool(test_action_script.requires_file).is_false()

func test_requires_saved_file_default_false() -> void:
	assert_bool(test_action_script.requires_saved_file).is_false()

func test_enable_default_true() -> void:
	assert_bool(test_action_script.enable).is_true()

func test_action_shortcut_exists() -> void:
	assert_object(test_action_script.action_shortcut).is_not_null()
	assert_object(test_action_script.action_shortcut).is_instanceof(InputEventKey)

func test_is_enable_returns_enable_state() -> void:
	test_action_script.enable = true
	assert_bool(test_action_script.is_enable()).is_true()
	test_action_script.enable = false
	assert_bool(test_action_script.is_enable()).is_false()

func test_check_option_extra_default_true() -> void:
	var result = test_action_script._check_option_extra()
	assert_bool(result).is_true()

func test_check_option_no_requirements() -> void:
	test_action_script.requires_file = false
	test_action_script.requires_saved_file = false
	test_action_script._check_option()
	assert_bool(test_action_script.enable).is_true()

func test_check_option_requires_file_enabled() -> void:
	test_action_script.requires_file = true
	Global.set_editor_disabled(false)
	test_action_script._check_option()
	assert_bool(test_action_script.enable).is_true()

func test_check_option_requires_file_disabled() -> void:
	test_action_script.requires_file = true
	var original_state = Global.is_editor_disabled()
	Global.set_editor_disabled(true)
	test_action_script._check_option()
	assert_bool(test_action_script.enable).is_false()
	Global.set_editor_disabled(original_state)

func test_enable_setter_updates_menu_state() -> void:
	add_child(test_action_script)
	await get_tree().process_frame
	test_action_script.enable = false
	assert_bool(test_menu.is_item_disabled(test_menu.get_item_index(100))).is_true()

func test_enable_setter_enables_menu_item() -> void:
	add_child(test_action_script)
	await get_tree().process_frame
	test_action_script.enable = false
	test_action_script.enable = true
	assert_bool(test_menu.is_item_disabled(test_menu.get_item_index(100))).is_false()

func test_action_scripts() -> void:
	for i in DirAccess.get_files_at(S.FOLDER_ACTION_SCRIPTS):
		if i.ends_with(".uid"):
			continue
		var script: Node = load(S.FOLDER_ACTION_SCRIPTS.path_join(i)).new()
		if not script is MultiActionScript:
			assert_object(script).is_inheriting(ActionScript).append_failure_message("{0} is {1}".format([i, script.get_class()]))
		script.free()
