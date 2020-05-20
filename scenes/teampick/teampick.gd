extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func check_can_start():
	if get_node("TeamIconSlotAway").teamname and get_node("TeamIconSlotHome").teamname:
		show_start(true)
	else:
		show_start(false)

func show_start(toggle):
	if toggle:
		get_node("Begin/FadePlayer/Begin").set_visible(true)
	else:
		get_node("Begin/FadePlayer/Begin").set_visible(false)

func start():
	var hometeam = get_node("TeamIconSlotHome").teamname
	var awayteam = get_node("TeamIconSlotAway").teamname
# warning-ignore:return_value_discarded
	get_tree().change_scene("scenes/game/game.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
