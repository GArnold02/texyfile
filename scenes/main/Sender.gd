extends Node


func _on_Peers_sending_begun(targets: PoolStringArray, paths: PoolStringArray):
	for i in targets:
		print(i)
	
	for i in paths:
		print(i)
