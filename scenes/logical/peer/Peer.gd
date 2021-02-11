extends Node

signal peer_registered(id, name)

export var server_path: NodePath
export var jobs_path: NodePath
export var status_bar_path: NodePath

onready var server: Node = get_node(server_path) as Node
onready var jobs: Control = get_node(jobs_path) as Control
onready var status_bar: Control = get_node(status_bar_path) as Control

var is_receiving: bool
var sender_name: String
var received_paths: PoolStringArray

var is_sending: bool
var accept_pending: Array
var accepted: Array

var peer_ids: Dictionary = {
	
}


func _ready():
	
	# warning-ignore:return_value_discarded
	connect("peer_registered", server, "_on_peer_registered")
	
	# warning-ignore:return_value_discarded
	jobs.get_peers().connect("sending_begun", self, "_on_sending_begun")
	
	# warning-ignore:return_value_discarded
	jobs.get_receive().connect("user_accepted", self, "_on_receive_accepted")
	
	# warning-ignore:return_value_discarded
	jobs.get_receive().connect("user_declined", self, "_on_receive_declined")
	
	# warning-ignore:return_value_discarded
	jobs.get_receive().connect("user_aborted", self, "_on_receive_aborted")
	
	_connect_to_server()


func _on_connect_succeeded():
	rpc_id(1, "register", Settings.params.nickname)
	status_bar.set_status("connected")


func _on_connect_failed():
	print("Connection failed")
	status_bar.set_status("disconnected")
	$RetryTimer.start()


func _on_server_disconnected():
	status_bar.set_status("disconnected")
	$RetryTimer.start()


func _on_sending_begun(targets: PoolStringArray, paths: PoolStringArray):
	is_sending = true
	accept_pending = targets
	$Sender.paths = paths
	
	for target in targets:
		var id: int = peer_ids[target]
		rpc_id(id, "ask_send", Settings.params.nickname,  paths)
	
	jobs.push_current("Send")
	jobs.get_send().set_recipients(targets)


func _on_receive_accepted():
	rpc_id(peer_ids[sender_name], "accept_send")
	
	var names: PoolStringArray = paths_to_names(received_paths)
	$Receiver.file_names = names
	jobs.get_receive().populate_with_files(names)


func _on_receive_declined():
	rpc_id(peer_ids[sender_name], "decline_send")
	
	is_receiving = false
	sender_name = ""


func _on_receive_aborted():
	rpc_id(peer_ids[sender_name], "receiver_aborted_send")
	
	is_receiving = false
	sender_name = ""


func _connect_to_server():
	get_tree().network_peer = null
	
	var net: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	
	# warning-ignore:return_value_discarded
	net.connect("connection_succeeded", self, "_on_connect_succeeded")
	
	# warning-ignore:return_value_discarded
	net.connect("connection_failed", self, "_on_connect_failed")
	
	# warning-ignore:return_value_discarded
	net.connect("server_disconnected", self, "_on_server_disconnected")
	
	# warning-ignore:return_value_discarded
	net.create_client(Settings.params.hostname, Settings.params.port)
	get_tree().network_peer = net


func _get_peer_name(id: int) -> String:
	for k in peer_ids:
		if peer_ids[k] == id:
			return k
	
	return "null"


func _on_RetryTimer_timeout():
	status_bar.set_status("connecting")
	_connect_to_server()


func _check_everyone_accepted():
	if accept_pending.empty():
		$Sender.begin(accepted)


remote func register(name: String):
	var id: int = get_tree().get_rpc_sender_id()
	emit_signal("peer_registered", id, name)


remote func peer_joined(name: String, id: int):
	peer_ids[name] = id
	jobs.get_peers().add_peer(name)


remote func peer_left(name: String):
	# warning-ignore:return_value_discarded
	peer_ids.erase(name)
	jobs.get_peers().remove_peer(name)


remote func ask_send(sender: String, paths: PoolStringArray):
	print("%s asked to send" % sender)
	
	if is_sending or is_receiving:
		rpc_id(peer_ids[sender], "decline_send")
		print("...but it was declined!")
		return
	
	is_receiving = true
	sender_name = sender
	received_paths = paths
	
	jobs.get_receive().ask_for_confirmation(sender, paths.size())
	jobs.push_current("Receive")


remote func accept_send():
	var who: int = get_tree().get_rpc_sender_id()
	var who_name: String = _get_peer_name(who)
	
	jobs.get_send().recipient_accepted(who_name)
	accept_pending.erase(who_name)
	accepted.push_back(who)
	
	_check_everyone_accepted()


remote func decline_send():
	var who: int = get_tree().get_rpc_sender_id()
	var who_name: String = _get_peer_name(who)
	
	jobs.get_send().recipient_aborted(who_name)
	accept_pending.erase(who_name)
	
	_check_everyone_accepted()


remote func receiver_aborted_send():
	var who: int = get_tree().get_rpc_sender_id()
	jobs.get_send().recipient_aborted(_get_peer_name(who))
	$Sender.receiver_ids.erase(who)
	$Sender.received.erase(who)


func paths_to_names(paths: PoolStringArray) -> PoolStringArray:
	var arr: PoolStringArray = []
	for path in paths:
		var unix_path: String = path.replace("\\", "/")
		var tokens: PoolStringArray = unix_path.split("/")
		arr.push_back(tokens[tokens.size() - 1])
	
	return arr
