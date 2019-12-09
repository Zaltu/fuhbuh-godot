extends Label

signal sleep_done

func setText(text):
	self.text = text
	print("text set to: %s" % text)
	var now = OS.get_ticks_msec()
	yield(get_tree().create_timer(1.0), "timeout")  # TODO doing this to ensure time between dispay updates
	emit_signal("sleep_done")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
