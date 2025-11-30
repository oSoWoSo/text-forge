class_name ShortcutMap
extends Resource
## A [Resource] class to store multiple shortcut keys in one file.

## Map to store each shortcut with one string.
@export var map: Dictionary[String, InputEventKey] = {}

## Returns saved [InputEventKey] shortcut for givrn [param name] or empty [InputEventKey].
func get_shortcut(name: String) -> InputEventKey:
	return map.get(name, InputEventKey.new())
