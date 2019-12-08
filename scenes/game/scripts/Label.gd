extends Label

func setText(text):
	self.text = text
	yield(get_tree().create_timer(1.0), "timeout")  # TODO doing this to ensure time between dispay updates

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
