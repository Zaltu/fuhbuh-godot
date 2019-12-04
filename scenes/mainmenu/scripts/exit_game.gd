extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect the current button to the exit game functionality.
	self.connect("pressed", self, "_exit_game")


# Completely exit the game. Only use for end of session.
func _exit_game():
	get_tree().quit()
