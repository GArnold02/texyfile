extends CenterContainer


func popup(sender: String, file_count: int):
	var label_msg: Label = $PanelContainer/List/Message
	label_msg.text = "{s} wants to send you {f} files. Do you accept?".format(
		{
			"s": sender,
			"f": file_count
		}
	)
	
	show()
