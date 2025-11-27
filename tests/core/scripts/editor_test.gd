# GdUnit generated TestSuite
class_name EditorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://core/scripts/editor.gd'

var editor: Editor

func before_test() -> void:
	editor = auto_free(Editor.new())
	add_child(editor)
	# Wait for _ready to complete
	await get_tree().process_frame

func test_ready_creates_type_timer() -> void:
	assert_object(editor.type_timer).is_not_null()
	assert_object(editor.type_timer).is_instanceof(Timer)

func test_type_timer_configured_correctly() -> void:
	assert_float(editor.type_timer.wait_time).is_equal(0.3)
	assert_bool(editor.type_timer.one_shot).is_true()

func test_ready_sets_gutter_clickable() -> void:
	# Gutter 0 should be clickable for bookmarks
	assert_bool(editor.is_gutter_clickable(0)).is_true()

func test_type_timer_is_child_of_editor() -> void:
	assert_bool(editor.type_timer.get_parent() == editor).is_true()

func test_get_char_index_single_line() -> void:
	editor.text = "Hello World"
	var index := editor.get_char_index(0, 6)
	assert_int(index).is_equal(6)

func test_get_char_index_at_start() -> void:
	editor.text = "Hello World"
	var index := editor.get_char_index(0, 0)
	assert_int(index).is_equal(0)

func test_get_char_index_at_end() -> void:
	editor.text = "Hello"
	var index := editor.get_char_index(0, 5)
	assert_int(index).is_equal(5)

func test_get_char_index_multiline() -> void:
	editor.text = "Line 1\nLine 2\nLine 3"
	# Character index at line 1, column 0 should be 7 (length of "Line 1\n")
	var index := editor.get_char_index(1, 0)
	assert_int(index).is_equal(7)

func test_get_char_index_multiline_with_offset() -> void:
	editor.text = "First\nSecond\nThird"
	# Line 1, column 3 = "First\n" (6) + 3 = 9
	var index := editor.get_char_index(1, 3)
	assert_int(index).is_equal(9)

func test_get_char_index_third_line() -> void:
	editor.text = "A\nB\nC"
	# Line 2, column 0 = "A\n" (2) + "B\n" (2) = 4
	var index := editor.get_char_index(2, 0)
	assert_int(index).is_equal(4)

func test_get_char_index_empty_text() -> void:
	editor.text = ""
	var index := editor.get_char_index(0, 0)
	assert_int(index).is_equal(0)

func test_is_selection_in_line_caret_only() -> void:
	editor.text = "Line 1\nLine 2\nLine 3"
	editor.set_caret_line(1)
	editor.set_selection_origin_line(1)
	editor.deselect()
	# With no active selection, only the caret line should be considered "in selection"
	assert_bool(editor.is_selection_in_line(0)).is_false()
	assert_bool(editor.is_selection_in_line(1)).is_true()
	assert_bool(editor.is_selection_in_line(2)).is_false()

func test_is_selection_in_line_with_selection() -> void:
	editor.text = "Line 1\nLine 2\nLine 3\nLine 4"
	editor.select(1, 0, 3, 0)
	# Lines 1, 2, 3 should be in selection
	assert_bool(editor.is_selection_in_line(1)).is_true()
	assert_bool(editor.is_selection_in_line(2)).is_true()
	assert_bool(editor.is_selection_in_line(3)).is_true()
	# Line 0 and 4 should not be in selection
	assert_bool(editor.is_selection_in_line(0)).is_false()
	assert_bool(editor.is_selection_in_line(4)).is_false()

func test_is_selection_in_line_reversed_selection() -> void:
	editor.text = "Line 1\nLine 2\nLine 3\nLine 4"
	# Select from line 3 to line 1 (reverse)
	editor.select(3, 0, 1, 0)
	# Should still work correctly
	assert_bool(editor.is_selection_in_line(1)).is_true()
	assert_bool(editor.is_selection_in_line(2)).is_true()
	assert_bool(editor.is_selection_in_line(3)).is_true()

func test_is_selection_in_line_single_line_selection() -> void:
	editor.text = "Line 1\nLine 2\nLine 3"
	editor.select(1, 0, 1, 6)
	assert_bool(editor.is_selection_in_line(0)).is_false()
	assert_bool(editor.is_selection_in_line(1)).is_true()
	assert_bool(editor.is_selection_in_line(2)).is_false()

func test_on_text_changed_starts_timer() -> void:
	editor.type_timer.stop()
	assert_bool(editor.type_timer.is_stopped()).is_true()

	editor._on_text_changed()

	assert_bool(editor.type_timer.is_stopped()).is_false()
	assert_float(editor.type_timer.time_left).is_greater(0.0)

func test_on_text_changed_restarts_timer() -> void:
	editor.type_timer.start()
	var first_time_left := editor.type_timer.time_left
	await get_tree().create_timer(0.1).timeout

	editor._on_text_changed()

	# Timer should have been restarted, so time_left should be close to wait_time
	assert_float(editor.type_timer.time_left).is_greater_equal(first_time_left)

func test_on_gutter_clicked_not_editable_does_nothing() -> void:
	editor.editable = false
	editor.text = "Line 1\nLine 2"

	editor._on_gutter_clicked(0, 0)

	assert_bool(editor.is_line_bookmarked(0)).is_false()

func test_on_gutter_clicked_wrong_gutter_does_nothing() -> void:
	editor.editable = true
	editor.text = "Line 1\nLine 2"

	# Gutter 1 should not toggle bookmarks (only gutter 0)
	editor._on_gutter_clicked(0, 1)

	assert_bool(editor.is_line_bookmarked(0)).is_false()

func test_on_gutter_clicked_gutter_2_does_nothing() -> void:
	editor.editable = true
	editor.text = "Line 1\nLine 2"

	editor._on_gutter_clicked(0, 2)

	assert_bool(editor.is_line_bookmarked(0)).is_false()

func test_on_gutter_clicked_sets_bookmark() -> void:
	editor.editable = true
	editor.text = "Line 1\nLine 2\nLine 3"

	editor._on_gutter_clicked(1, 0)

	assert_bool(editor.is_line_bookmarked(1)).is_true()

func test_on_gutter_clicked_toggles_bookmark_on() -> void:
	editor.editable = true
	editor.text = "Line 1\nLine 2\nLine 3"
	assert_bool(editor.is_line_bookmarked(1)).is_false()

	editor._on_gutter_clicked(1, 0)

	assert_bool(editor.is_line_bookmarked(1)).is_true()

func test_on_gutter_clicked_toggles_bookmark_off() -> void:
	editor.editable = true
	editor.text = "Line 1\nLine 2\nLine 3"
	editor.set_line_as_bookmarked(1, true)
	assert_bool(editor.is_line_bookmarked(1)).is_true()

	editor._on_gutter_clicked(1, 0)

	assert_bool(editor.is_line_bookmarked(1)).is_false()

func test_on_gutter_clicked_multiple_lines() -> void:
	editor.editable = true
	editor.text = "Line 1\nLine 2\nLine 3\nLine 4"

	# Bookmark lines 0, 2, 3
	editor._on_gutter_clicked(0, 0)
	editor._on_gutter_clicked(2, 0)
	editor._on_gutter_clicked(3, 0)

	assert_bool(editor.is_line_bookmarked(0)).is_true()
	assert_bool(editor.is_line_bookmarked(1)).is_false()
	assert_bool(editor.is_line_bookmarked(2)).is_true()
	assert_bool(editor.is_line_bookmarked(3)).is_true()

func test_on_gutter_clicked_toggle_sequence() -> void:
	editor.editable = true
	editor.text = "Line 1\nLine 2"

	# Click once - should set bookmark
	editor._on_gutter_clicked(0, 0)
	assert_bool(editor.is_line_bookmarked(0)).is_true()

	# Click again - should remove bookmark
	editor._on_gutter_clicked(0, 0)
	assert_bool(editor.is_line_bookmarked(0)).is_false()

	# Click third time - should set again
	editor._on_gutter_clicked(0, 0)
	assert_bool(editor.is_line_bookmarked(0)).is_true()
