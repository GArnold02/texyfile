extends PanelContainer


onready var icon: TextureRect = $List/Connection/Icon
onready var label: Label = $List/Connection/Label


const status_dict: Dictionary = {
	"connecting": {
		"icon": preload("res://icons/connecting.tres"),
		"text": "Connecting",
	},
	
	"connected": {
		"icon": preload("res://icons/connected.png"),
		"text": "Connected",
	},
	
	"disconnected": {
		"icon": preload("res://icons/disconnected.png"),
		"text": "Disconnected",
	},
	
	"hosting": {
		"icon": preload("res://icons/connected.png"),
		"text": "Hosting",
	}
}


func _ready():
	set_status("connecting")


func set_status(status: String):
	var info: Dictionary = status_dict[status]
	
	icon.texture = info["icon"]
	label.text = info["text"]
