extends Label

signal sleep_done

func delayed_display(text):
	self.text = text
	print("text set to: %s" % text)
	#var now = OS.get_ticks_msec()
	# TODO doing this to ensure time between dispay updates
	# For some reason the actual pause between updates is incredibly arbitrary
	yield(get_tree().create_timer(2.0), "timeout")
	#var after = OS.get_ticks_msec()
	#print(now)
	#print(after)
	emit_signal("sleep_done")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
