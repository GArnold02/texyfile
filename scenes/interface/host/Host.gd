extends PanelContainer


signal host_requested(port)
signal host_force_stop

onready var port_edit: LineEdit = $Body/List/Control/List/Port/Value
onready var start: Button = $Body/List/Control/List/Start
onready var stop: Button = $Body/List/Control/List/Stop
onready var logger: TextEdit = $Body/List/Log/List/Text

var port: int = 0

func _ready():
	# warning-ignore:return_value_discarded
	start.connect("pressed", self, "_on_start_pressed")
	
	# warning-ignore:return_value_discarded
	stop.connect("pressed", self, "_on_stop_pressed")
	
	# warning-ignore:return_value_discarded
	port_edit.connect("text_changed", self, "_on_port_changed")


func _on_start_pressed():
	OS.set_window_title("Texyfile - Server")
	
	start.disabled = true
	stop.disabled = false
	port_edit.editable = false
	
	emit_signal("host_requested", port)


func _on_stop_pressed():
	start.disabled = false
	stop.disabled = true
	port_edit.editable = true
	
	emit_signal("host_force_stop")


func _on_port_changed(new_text: String):
	port = int(new_text)
	start.disabled = port == 0


func push_message(msg: String):
	logger.text += "%s\n" % msg
