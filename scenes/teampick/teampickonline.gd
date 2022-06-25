extends Control

var hometeam

func _ready():
	global.connect("both_players_ready", self, "_on_both_players_ready")

func check_can_start():
	if get_node("TeamIconSlotHome").teamname:
		show_start(true)
	else:
		show_start(false)


func show_start(toggle):
	if toggle:
		get_node("Begin/FadePlayer/Begin").set_visible(true)
	else:
		get_node("Begin/FadePlayer/Begin").set_visible(false)
		get_node("Begin/FadePlayer/Begin")._on_Begin_mouse_exited()


func start():
	hometeam = get_node("TeamIconSlotHome").teamname

	global.send_packet(hometeam)
	show_start(false)
	get_node("WAITING").set_visible(true)


func _on_both_players_ready(packet):
	var away
	if packet[0][0] == global.nameid:
		away = packet[1][1]
	else:
		away = packet[0][1]

	global.set_params([hometeam, away])
# warning-ignore:return_value_discarded
	get_tree().change_scene("scenes/game/gameonline.tscn")
