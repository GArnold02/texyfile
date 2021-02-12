extends PanelContainer


signal setting_changed
signal saved

export var download_dir_dialog_path: NodePath

onready var download_dir_dialog: FileDialog = get_node(
	download_dir_dialog_path
) as FileDialog

func _ready():
	# warning-ignore:return_value_discarded
	download_dir_dialog.connect(
		"dir_selected", self, "_on_download_dir_selected"
	)


func _check_validity():
	if(
		not Settings.params.hostname.empty() and
		not Settings.params.port == 0 and
		not Settings.params.nickname.empty() and
		not Settings.params.download_dir.empty()
	):
		$Body/Save.disabled = false
		emit_signal("setting_changed")
	else:
		$Body/Save.disabled = true


func _on_visibility_changed():
	if visible:
		load_settings()


func _on_Hostname_text_changed(new_text: String):
	Settings.params.hostname = new_text
	_check_validity()


func _on_Port_text_changed(new_text: String):
	Settings.params.port = int(new_text)
	_check_validity()


func _on_Nickname_text_changed(new_text: String):
	Settings.params.nickname = new_text
	_check_validity()


func _on_ChooseDir_pressed():
	download_dir_dialog.popup_centered()


func _on_Save_pressed():
	Settings.save_settings()
	emit_signal("saved")


func _on_download_dir_selected(dir: String):
	Settings.params.download_dir = dir
	$Body/Content/List/DownloadDir/Body/Parameters/Directory.text = dir
	_check_validity()


func load_settings():
	Settings.load_settings()
	$Body/Content/List/Server/Body/Paramaters/Hostname.text = Settings.params.hostname
	$Body/Content/List/Server/Body/Paramaters/Port.text = String(Settings.params.port)
	$Body/Content/List/Nickname/Body/Nickname.text = Settings.params.nickname
	$Body/Content/List/DownloadDir/Body/Parameters/Directory.text = Settings.params.download_dir
