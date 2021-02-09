extends PanelContainer

signal user_accepted
signal user_declined
signal user_aborted


func _on_Abort_pressed():
	get_parent().pop_current()
	emit_signal("user_aborted")


func _on_Accept_pressed():
	$Confirm.hide()
	$Main.show()
	emit_signal("user_accepted")


func _on_Decline_pressed():
	$Confirm.hide()
	get_parent().pop_current()
	emit_signal("user_declined")


func ask_for_confirmation(sender: String, file_count: int):
	$Main.hide()
	$Confirm.popup(sender, file_count)


func populate_with_files(paths: PoolStringArray):
	var file_list: Control = $Main/Status/List/Scroll/Files
	
	for path in paths:
		file_list.add_file(path)
