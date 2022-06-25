extends TextureButton


func _ready():
# warning-ignore:return_value_discarded
	global.connect("connection_confirmed", self, "_on_connection_confirmed")

func _on_online_versus_pressed():
	# Connect to server
	global.connect_to_server()

func _on_connection_confirmed():
	print("Changing scenes")
	#Change to one-team-picker
# warning-ignore:return_value_discarded
	get_tree().change_scene("scenes/teampick/teampickonline.tscn")
