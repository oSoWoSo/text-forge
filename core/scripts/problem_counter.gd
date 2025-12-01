class_name ProblemCounter
extends HBoxContainer
## Shows count of errors and warnings.

## Error count panel.
@export var error_panel: PanelContainer
## Error count label.
@export var error_count: Label
## Warning count panel.
@export var warning_panel: PanelContainer
## Warning count label.
@export var warning_count: Label

func _ready() -> void:
	Signals.problems_updated.connect(_update_count)


## Updates errors and warnings based on mode's linting result.
func _update_count(problems: Array) -> void:
	error_count.text = str(problems.filter(func(p): return p["error"] == true).size())
	warning_count.text = str(problems.filter(func(p): return p["error"] == false).size())
	error_panel.visible = error_count.text != "0"
	warning_panel.visible = warning_count.text != "0"
