extends CenterContainer


func _ready():
	var settings_file: File = File.new()
	if !settings_file.file_exists("user://settings"):
		open_settings()


func open_settings():
	$Settings.show()
	show()


func open_send_dialog():
	$SendDialog.popup_centered()
	show()


func _on_Settings_hide():
	hide()
