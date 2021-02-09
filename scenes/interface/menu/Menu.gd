extends PanelContainer


export var settings_path: NodePath
export var jobs_path: NodePath

onready var settings: Control = get_node(settings_path) as Control
onready var jobs: Control = get_node(jobs_path) as Control

var previous_current: String

func _on_Exit_pressed():
	get_tree().quit()


func _on_Settings_pressed():
	settings.visible = not settings.visible


func _on_Host_pressed():
	if jobs.get_current() != "Host":
		jobs.push_current("Host")
	else:
		jobs.pop_current()


func _on_settings_hide():
	$List/Settings.pressed = false
