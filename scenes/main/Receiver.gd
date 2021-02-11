extends Node


onready var sender = get_node("../Sender")

var file_names: PoolStringArray
var file: File = null


func _finish_previous_file():
	if file != null:
		file.close()


remote func next_file_info(file_id: int, file_size: int):
	_finish_previous_file()
	
	file = File.new()
	file.open(
		Settings.params.download_dir + "/%s" % file_names[file_id],
		File.WRITE
	)


remote func fragment_received(buf: PoolByteArray):
	var sender_id: int = get_tree().get_rpc_sender_id()
	sender.rpc_id(sender_id, "fragment_confirmed")
	file.store_buffer(buf)


remote func file_arrived(file_id: int):
	_finish_previous_file()
	print("%s has arrived" % file_names[file_id])
