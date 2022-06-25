extends TextureButton


func _pressed():
	print("PLAY (foot) BALL!")
	get_node("../../../").start()


func _on_Begin_mouse_entered():
	var animplayer = get_parent()
	animplayer.seek(0, true)
	animplayer.stop()
	get_node("../../FireAnimPlayer/fire").set_visible(true)
	get_node("../../FireAnimPlayer/fire2").set_visible(true)


func _on_Begin_mouse_exited():
	get_parent().play("FlashBegin")
	get_node("../../FireAnimPlayer/fire").set_visible(false)
	get_node("../../FireAnimPlayer/fire2").set_visible(false)
