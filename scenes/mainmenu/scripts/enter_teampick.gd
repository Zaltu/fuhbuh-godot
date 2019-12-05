extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_teampick")

func _teampick():
	get_tree().change_scene("scenes/game/game.tscn")
