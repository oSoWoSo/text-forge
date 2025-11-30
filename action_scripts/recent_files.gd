extends MultiActionScript

func _run_action(item_id, popup) -> void:
	if Global.has_unsaved_change():
		Global.send_notification(
			Global.Notification.INFO,
			"Please do this action again",
			"You have unsaved changes, but there isn't support for loading recent files after save/discard changes."
		)
		await U.wait(1)
		Signals.close_file.emit()
		return
	Signals.open_file.emit(popup.get_item_text(popup.get_item_index(item_id)))
