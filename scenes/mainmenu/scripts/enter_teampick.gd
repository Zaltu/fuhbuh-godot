extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pressed", self, "_teampick")

func _teampick():
	# Go straight to game for now. Teampicker is TODO
	get_tree().change_scene("scenes/game/game.tscn")
