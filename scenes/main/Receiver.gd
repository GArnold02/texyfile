extends Node


onready var sender = get_node("../Sender")
var sender_id: int


func request_next_fragment():
	sender.rpc_id(
		sender_id,
		"next_fragment_requested"
	)


remote func initiate_reception(s_id: int):
	sender_id = s_id
	request_next_fragment()
