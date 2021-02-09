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
