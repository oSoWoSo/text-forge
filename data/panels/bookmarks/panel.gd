extends TextForgePanel

const ITEM = preload("res://data/panels/bookmarks/item_panel.tscn")

@export var items: VBoxContainer

func _ready() -> void:
	Global.get_editor().type_timer_timeout.connect(_update_bookmarks)
	Global.get_editor().gutter_clicked.connect(_update_bookmarks.call_deferred.unbind(2))


func _update_bookmarks() -> void:
	var bookmarks := Global.get_editor().get_bookmarked_lines()
	for e in items.get_child_count():
		if e < bookmarks.size():
			items.get_child(e).show()
		else:
			items.get_child(e).hide()
	for i in bookmarks.size():
		while i >= items.get_child_count():
			items.add_child(ITEM.instantiate())
		var c: PanelContainer = items.get_child(i)
		c.update(Global.get_editor().get_line(bookmarks[i]), bookmarks[i])
