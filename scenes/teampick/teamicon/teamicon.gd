extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var teamname = ""

func get_drag_data(_pos):
	var tempicon = load("res://scenes/teampick/teamicon/teamicon.tscn").instance()
	tempicon.set_texture(get_texture())
	set_drag_preview(tempicon)
	return self.teamname

func init(_teamname):
	set_texture(load("res://assets/teams/"+_teamname+".png"))
	self.teamname = _teamname


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
