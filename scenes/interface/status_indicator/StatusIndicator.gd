extends PanelContainer


const status_dict: Dictionary = {
	"waiting": {
		"icon": preload("res://icons/waiting.png"),
		"text": "Waiting",
	},
	
	"ready": {
		"icon": preload("res://icons/ready.png"),
		"text": "Ready",
	},
	
	"aborted": {
		"icon": preload("res://icons/error.png"),
		"text": "Aborted",
	},
	
	"receiving": {
		"icon": preload("res://icons/receiving.png"),
		"text": "Receiving",
	},
	
	"arrived": {
		"icon": preload("res://icons/ready.png"),
		"text": "Arrived",
	}
}


export var label: String

onready var label_name: Label = $Elements/Name
onready var pb_progress: ProgressBar = $Elements/Progress
onready var tr_status_icon: TextureRect = $Elements/StatusIcon
onready var label_status: Label = $Elements/Status


func _ready():
	label_name.text = label


func set_status(status: String):
	var info: Dictionary = status_dict[status]
	
	tr_status_icon.texture = info["icon"]
	label_status.text = info["text"]


func set_progress(progress: float):
	pb_progress.value = progress
