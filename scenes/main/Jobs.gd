extends Control


var current: Control = null
var stack: Array = []


func _ready():
	push_current("Peers")


func _hide_all():
	for child in get_children():
		child.hide()


func push_current(job: String):
	var node: Control = get_node(job) as Control
	stack.push_back(node)
	
	_hide_all()
	stack.back().show()


func pop_current():
	stack.pop_back()
	
	_hide_all()
	stack.back().show()


func get_current()-> String:
	return stack.back().name


func get_host() -> Control:
	return $Host as Control


func get_peers() -> Control:
	return $Peers as Control


func get_send() -> Control:
	return $Send as Control


func get_receive() -> Control:
	return $Receive as Control
