extends VBoxContainer


var status_dict: Dictionary = {}


# warning-ignore:unused_argument
func add_file(file_name: String):
	var scn = preload("res://scenes/interface/status_indicator/StatusIndicator.tscn")
	
	var status = scn.instance()
	status.label = file_name
	
	status_dict[file_name] = status
	add_child(status)
	
	status.set_status("waiting")


func clear():
	for child in get_children():
		child.queue_free()


func set_file_progress(file_name: String, progress: float):
	var status = status_dict[file_name]
	status.set_progress(progress)
	status.set_status("receiving")


func set_file_arrived(file_name: String):
	var status = status_dict[file_name]
	status.set_status("arrived")
