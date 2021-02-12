extends PanelContainer

signal sending_begun(targets, paths)

export var send_dialog_path: NodePath

onready var item_list: ItemList = $List/Items
onready var send_button: Button = $List/Buttons/Send
onready var send_dialog: FileDialog = get_node(
	send_dialog_path
) as FileDialog


func _ready():
	# warning-ignore:return_value_discarded
	item_list.connect("multi_selected", self, "_on_item_selected")
	
	# warning-ignore:return_value_discarded
	send_dialog.connect("files_selected", self, "_on_files_selected")


func _on_Send_pressed():
	send_dialog.popup_centered()


func _on_SelectAll_pressed():
	for i in range(0, item_list.get_item_count()):
		item_list.select(i, false)
	
	_guard_send_button()


func _on_DeselectAll_pressed():
	item_list.unselect_all()
	_guard_send_button()


func _on_item_selected(_index: int, _selected: bool):
	_guard_send_button()


func _on_files_selected(paths: PoolStringArray):
	var targets: PoolStringArray = []
	for i in item_list.get_selected_items():
		targets.push_back(item_list.get_item_text(i))
	
	emit_signal("sending_begun", targets, paths)


func _guard_send_button():
	send_button.disabled = item_list.get_selected_items().size() == 0


func add_peer(name: String):
	item_list.add_item(name)


func remove_peer(name: String):
	for i in range(0, item_list.get_item_count()):
		if item_list.get_item_text(i) == name:
			item_list.remove_item(i)
			break


func clear():
	item_list.clear()
