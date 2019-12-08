extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	self.connect("pressed", self, "_teampick")

func _teampick():
	# Go straight to game for now. Teampicker is TODO
# warning-ignore:return_value_discarded
	get_tree().change_scene("scenes/game/game.tscn")
