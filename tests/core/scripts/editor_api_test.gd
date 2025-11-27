# GdUnit generated TestSuite
class_name EditorAPIBookmarkTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://core/scripts/editor_api.gd'

# Note: This test focuses on the bookmark functionality added to EditorAPI
# Full EditorAPI testing would require extensive mocking and is better suited
# for integration tests due to heavy dependencies on Global, Settings, etc.

func test_save_bookmarks_method_exists() -> void:
	var editor_api := EditorAPI.new()
	assert_bool(editor_api.has_method("_save_bookmarks")).is_true()
	editor_api.free()

func test_load_bookmarks_method_exists() -> void:
	var editor_api := EditorAPI.new()
	assert_bool(editor_api.has_method("_load_bookmarks")).is_true()
	editor_api.free()

func test_editor_api_extends_control() -> void:
	var editor_api := EditorAPI.new()
	assert_object(editor_api).is_instanceof(Control)
	editor_api.free()

# Integration tests for bookmark persistence would go here
# but require full application context with Global, Settings, etc.
