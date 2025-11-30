extends MultiActionScript

func _run_action(item_id, popup) -> void:
	if Global.has_unsaved_change():
		Global.send_notification(Global.Notification.INFO, "Please do this action again", "You have unsaved changes, but there isn't support to create a new file before saving or discarding changes.")
		await U.wait(1)
		Signals.close_file.emit()
		return
	Global.get_core().load_template(popup.get_item_text(popup.get_item_index(item_id)))
