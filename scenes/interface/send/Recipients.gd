extends VBoxContainer


var rec_status: Dictionary = {}


func add_recipient(rec_name: String):
	var scn = preload("res://scenes/interface/status_indicator/StatusIndicator.tscn")
	var indicator = scn.instance()
	indicator.label = rec_name
	
	rec_status[rec_name] = indicator
	add_child(indicator)


func set_recipient_status(rec_name: String, status: String):
	rec_status[rec_name].set_status(status)
