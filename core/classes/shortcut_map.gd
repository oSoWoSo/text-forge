class_name ShortcutMap
extends Resource
## A [Resource] class to store multiple shortcut keys in one file.

## Map from shortcut name strings to their [InputEventKey] shortcuts.
@export var map: Dictionary[String, InputEventKey] = {}

## Returns saved [InputEventKey] shortcut for given [param name] or empty [InputEventKey].
func get_shortcut(name: String) -> InputEventKey:
	return map.get(name, InputEventKey.new())
