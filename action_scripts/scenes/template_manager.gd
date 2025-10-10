extends Window

@export var templates: ItemList
@export var preview_panel: VBoxContainer
@export var template_name: Label
@export var preview: RichTextLabel

func _ready() -> void:
	templates.clear()
	for t in DirAccess.get_files_at(S.globalize_path(S.FOLDER_TEMPLATES)):
		templates.add_item(t.get_basename())
	if templates.item_count == 0:
		templates.add_item("There is no templete to show!", null, false)
		templates.add_item("You can use Format > Save As Template to create new templates.", null, false)

func _on_item_list_item_selected(index: int) -> void:
	preview_panel.show()
	template_name.text = templates.get_item_text(index)
	preview.text = FileAccess.get_file_as_string(S.TEMPLATE_TEMPLATES.format([template_name.text]))


func _on_button_pressed() -> void:
	hide()
	Signals.open_file.emit(S.TEMPLATE_TEMPLATES.format([template_name.text]))
	await U.wait()
	queue_free()


func _on_button_2_pressed() -> void:
	OS.move_to_trash(S.globalize_path(S.TEMPLATE_TEMPLATES.format([template_name.text])))
	preview_panel.hide()
	_ready()
