extends Node

export var jobs_path: NodePath
export var peer_path: NodePath
export var status_bar_path: NodePath

onready var jobs: Node = get_node(jobs_path) as Node
onready var peer: Node = get_node(peer_path) as Node
onready var status_bar: Node = get_node(status_bar_path) as Node


var peers: Dictionary = {
	
}


func _on_Host_host_requested(port):
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "_on_peer_connected")
	
	# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "_on_peer_disconnected")
	
	var net: NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
	
	# warning-ignore:return_value_discarded
	net.create_server(port)
	get_tree().network_peer = net
	
	jobs.get_host().push_message("Started server on port %s." % port)
	status_bar.set_status("hosting")


func _on_Host_host_force_stop():
	get_tree().network_peer = null
	jobs.get_host().push_message("Stopped server.")
	
	peers.clear()


func _on_peer_connected(_id: int):
	pass


func _on_peer_disconnected(id: int):
	var name: String = peers[id]
	
	# warning-ignore:return_value_discarded
	jobs.get_host().push_message("%s disconnected." % name)
	peers.erase(id)
	peer.rpc("peer_left", name)


func _on_peer_registered(id, name):
	if peers.values().has(name):
		# Kick peer with duplicate name
		get_tree().network_peer.disconnect_peer(id)
		return
	
	peers[id] = name
	jobs.get_host().push_message("%s connected." % name)
	
	# Send self to others
	for p in peers:
		if p == id:
			continue
		
		peer.rpc_id(p, "peer_joined", name, id)
	
	# Send others to self
	for other in peers:
		if peers[other] == name:
			continue
			
		peer.rpc_id(id, "peer_joined", peers[other], other)
