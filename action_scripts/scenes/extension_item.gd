class_name ExtensionInstance
extends PanelContainer
## A panel to manage one extension.

## Extension name
@export var text: Label
## Action status [CheckBox]
@export var enable: CheckBox
## Uninstall button
@export var uninstall: Button
## Extension ID
var id: String

## Setups current item for another extension.
func setup(item_id: String, label: String, enabled: bool = false) -> ExtensionInstance:
	id = item_id
	text.text = label
	enable.button_pressed = enabled
	_on_status_toggled(enabled)
	show()
	return self


## Changes extension status.
func _on_status_toggled(toggled_on: bool) -> void:
	Extensions.set_extension_enabled(id, toggled_on)
	if toggled_on:
		enable.text = "Enabled "
	else:
		enable.text = "Disabled "


## Sends a confirmation request to uninstall extension.
func _on_uninstall_pressed() -> void:
	add_child(Factory.confirmation_dialog(
		"Are you sure you want to uninstall this extension?",
		"Yes",
		"Cancel",
		"Please Confirm",
		Callable(),
		_uninstall
	))


## Uninstalls extension.
func _uninstall() -> void:
	Extensions.uninstall_extension(id)
	await get_tree().process_frame
	queue_free()


## Requests file path to export extension.
func _on_export_pressed() -> void:
	add_child(Factory.file_dialog(
		FileDialog.FILE_MODE_SAVE_FILE,
		FileDialog.ACCESS_FILESYSTEM,
		["*.tfx;Text Forge Extensions;application/zip"],
		_export_self,
		true,
		OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)
	))


## Exports current extension.
func _export_self(path: String) -> void:
	var writer := ZIPPacker.new()
	var err := writer.open(path)
	if err:
		Global.send_notification(Global.Notification.ERROR, "Can't export extension!", "Error code: " + str(err))
		return
	for f in DirAccess.get_files_at(S.FOLDER_EXTENSIONS.path_join(id)):
		var src_path := S.FOLDER_EXTENSIONS.path_join(id).path_join(f)
		var file := FileAccess.open(src_path, FileAccess.READ)
		if not file:
			var open_err := FileAccess.get_open_error()
			Global.send_notification(
				Global.Notification.ERROR,
				"Can't export extension file!",
				"File: %s\nError code: %s" % [src_path, str(open_err)]
			)
			continue
		writer.start_file(id.path_join(f))
		writer.write_file(file.get_buffer(file.get_length()))
		file.close()
		writer.close_file()
	writer.close()
	Global.send_notification(Global.Notification.INFO, "Export extension completed.", "Exported file: " + path)
