extends PanelContainer


signal user_aborted

onready var recipient_list = $List/Status/List/Scroll/Recipients

func set_recipients(targets: PoolStringArray):
	for target in targets:
		recipient_list.add_recipient(target)
		recipient_list.set_recipient_status(target, "waiting")


func clear_recipients():
	for recipient in recipient_list.get_children():
		recipient.queue_free()


func recipient_accepted(rec_name: String):
	recipient_list.set_recipient_status(rec_name, "ready")


func recipient_aborted(rec_name: String):
	recipient_list.set_recipient_status(rec_name, "aborted")


func _on_Abort_pressed():
	get_parent().pop_current()
	emit_signal("user_aborted")
