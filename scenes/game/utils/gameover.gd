extends TextureButton

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	self.connect("pressed", self, "_exit_game")


# TODO this exits the game, make it go back to start instead.
func _exit_game():
	get_tree().quit()
