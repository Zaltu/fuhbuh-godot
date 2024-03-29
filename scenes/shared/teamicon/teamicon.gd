extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var teamname = ""

func get_drag_data(_pos):
	var tempicon = load("res://scenes/shared/teamicon/teamicon.tscn").instance()
	tempicon.set_texture(get_texture())
	tempicon._set_size(Vector2(0.01, 0.01))
	set_drag_preview(tempicon)
	return self.teamname

func init(_teamname):
	set_texture(load("res://assets/teams/"+_teamname+".png"))
	self.teamname = _teamname

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
