extends Node

const PATH: String = "user://settings"

var params: Dictionary = {
	hostname = "127.0.0.1",
	port = 5555,
	nickname = "someguy55",
	download_dir = "."
}


func _ready():
	# warning-ignore:return_value_discarded
	load_settings()

func save_settings():
	var file: File = File.new()
	
	# warning-ignore:return_value_discarded
	file.open(PATH, File.WRITE)
	
	file.store_var(params)
	file.close()


func load_settings() -> bool:
	var file: File = File.new()
	if file.file_exists(PATH):
		# warning-ignore:return_value_discarded
		file.open(PATH, File.READ)
		params = file.get_var()
		file.close()
		
#		randomize()
#		params.nickname = "peer%s" % int(rand_range(0, 999))
		return true
	
	return false
