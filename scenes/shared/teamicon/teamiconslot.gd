extends TextureRect


# Declare member variables here. Examples:
var teamname = ""

func can_drop_data(_position, data):
	return typeof(data) == TYPE_STRING

func drop_data(_position, data):
	set_child_texture(data)
	self.teamname = data
	get_parent().check_can_start()

func set_child_texture(_teamname):
	get_node("TeamIconImage").set_texture(load("res://assets/teams/"+_teamname+".png"))


# Called when the node enters the scene tree for the first time.
func _ready():
	set_size(Vector2(220, 220))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
