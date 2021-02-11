extends Node


signal send_finished

const FRAGMENT_SIZE: int = 8192

onready var receiver = get_node("../Receiver")

var paths: PoolStringArray
var receiver_ids: Array
var received: Array

var current_file_id: int
var current_file: File = null
var remaining_bytes: int

var current_fragment: int
var fragment_count: int



func _get_next_fragment_size() -> int:
	if remaining_bytes >= FRAGMENT_SIZE:
		remaining_bytes -= FRAGMENT_SIZE
		return FRAGMENT_SIZE
	else:
		var val: int = remaining_bytes
		remaining_bytes = 0
		return val


func _set_fragment_count():
	# warning-ignore:integer_division
	fragment_count = remaining_bytes / FRAGMENT_SIZE
	
	if remaining_bytes % FRAGMENT_SIZE > 0:
		fragment_count += 1


# Returns false when there are no more files left to be sent.
func _begin_next_file() -> bool:
	if current_file_id > 0:
		for rec in receiver_ids:
			receiver.rpc_id(rec, "file_arrived", current_file_id-1)
	
	# Check if this was the last file
	if current_file_id == paths.size():
		return false
	
	if current_file != null:
		current_file.close()
	
	current_file = File.new()
	
	# warning-ignore:return_value_discarded
	current_file.open(paths[current_file_id], File.READ)
	
	remaining_bytes = current_file.get_len()
	_set_fragment_count()
	
	for rec in receiver_ids:
		receiver.rpc_id(rec, "next_file_info", current_file_id, remaining_bytes)
	
	current_fragment = 0
	current_file_id += 1
	
	return true


func begin(ids: Array):
	receiver_ids = ids
	
	# warning-ignore:return_value_discarded
	_begin_next_file()
	
	send_next_fragment()


func send_next_fragment():
	var buf = current_file.get_buffer(_get_next_fragment_size())
	
	for rec in receiver_ids:
		receiver.rpc_id(rec, "fragment_received", buf)
	
	current_fragment += 1


remote func fragment_confirmed():
	var who: int = get_tree().get_rpc_sender_id()
	received.push_back(who)
	
	if received.size() == receiver_ids.size():
		received.clear()
		if current_fragment == fragment_count:
			if not _begin_next_file():
				emit_signal("send_finished")
				return # Don't send anything if there are no files left
		
		send_next_fragment()
