extends Node


onready var receiver = get_node("../Receiver")

var paths: PoolStringArray
var receiver_ids: Array


func begin(ids: Array):
	receiver_ids = ids
	for id in receiver_ids:
		receiver.rpc_id(id, "initiate_reception", get_tree().get_network_unique_id())


remote func next_fragment_requested():
	var rec: int = get_tree().get_rpc_sender_id()
