extends MultiActionScript

func _run_action(item_id, popup) -> void:
	if Global.get_file_name().ends_with("*"):
		Global.send_notification(Global.Notification.INFO, "Please do this action again", "You have unsaved changes, But there isn's support for create new file before save/discad changes.")
		await U.wait(1)
		Signals.close_file.emit()
		return
	Global.get_core().load_template(popup.get_item_text(popup.get_item_index(item_id)))
