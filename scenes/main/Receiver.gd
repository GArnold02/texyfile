extends Node

export var jobs_path: NodePath

onready var sender = get_node("../Sender")
onready var jobs = get_node(jobs_path)

var file_names: PoolStringArray
var file: File = null
var current_file_id: int
var received_bytes: int
var current_file_size: int


func _finish_previous_file():
	if file != null:
		file.close()


remote func next_file_info(file_id: int, file_size: int):
	_finish_previous_file()
	
	file = File.new()
	
	# warning-ignore:return_value_discarded
	file.open(
		Settings.params.download_dir + "/%s" % file_names[file_id],
		File.WRITE
	)
	
	received_bytes = 0
	current_file_id = file_id
	current_file_size = file_size


remote func fragment_received(buf: PoolByteArray):
	var sender_id: int = get_tree().get_rpc_sender_id()
	sender.rpc_id(sender_id, "fragment_confirmed")
	file.store_buffer(buf)
	
	received_bytes += buf.size()
	
	jobs.get_receive().set_file_progress(
		file_names[current_file_id],
		received_bytes / float(current_file_size)
	)


remote func file_arrived(file_id: int):
	_finish_previous_file()
	jobs.get_receive().set_file_arrived(file_names[file_id])
