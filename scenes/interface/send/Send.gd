extends PanelContainer


onready var recipient_list = $List/Status/List/Scroll/Recipients

func set_recipients(targets: PoolStringArray):
	for target in targets:
		recipient_list.add_recipient(target)
		recipient_list.set_recipient_status(target, "waiting")


func recipient_accepted(rec_name: String):
	recipient_list.set_recipient_status(rec_name, "ready")


func recipient_aborted(rec_name: String):
	recipient_list.set_recipient_status(rec_name, "aborted")
