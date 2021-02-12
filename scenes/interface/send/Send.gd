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


func set_file(file_name: String, id: int, count: int):
	var label_name: Label = $List/Progress/List/File/Name
	var label_count: Label = $List/Progress/List/File/Count
	label_name.text = file_name
	label_count.text = "%s/%s" % [id+1, count]


func set_progress(progress: float):
	var bar: ProgressBar = $List/Progress/List/Bar
	bar.value = progress


func _on_Abort_pressed():
	get_parent().pop_current()
	emit_signal("user_aborted")


func _on_visibility_changed():
	if visible:
		set_progress(0)
		set_file("", 0, 1)
