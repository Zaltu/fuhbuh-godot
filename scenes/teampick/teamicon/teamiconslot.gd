extends TextureRect


# Declare member variables here. Examples:
var teamname = ""

func can_drop_data(_position, data):
	return typeof(data) == TYPE_STRING

func drop_data(_position, data):
	get_node("TeamIconImage").set_texture(load("res://assets/teams/"+data+".png"))
	self.teamname = data
	get_parent().check_can_start()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
