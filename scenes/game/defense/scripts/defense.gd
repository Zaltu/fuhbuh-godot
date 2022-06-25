extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var GAME = get_node("/root/Game")

func _on_pressed_std():
	GAME.set_defplay("Standard")

func _on_pressed_shrty():
	GAME.set_defplay("Short Yardage")

func _on_pressed_sprd():
	GAME.set_defplay("Spread")

func _on_pressed_pps():
	GAME.set_defplay("Pass Prevent Short")

func _on_pressed_ppl():
	GAME.set_defplay("Pass Prevent Long")

func _on_pressed_bltz():
	GAME.set_defplay("Blitz")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func disable(on):
	for node in self.get_children():
		node.set_disabled(on)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	get_node("Standard").connect("pressed", self, "_on_pressed_std")
# warning-ignore:return_value_discarded
	get_node("ShortYardage").connect("pressed", self, "_on_pressed_shrty")
# warning-ignore:return_value_discarded
	get_node("Spread").connect("pressed", self, "_on_pressed_sprd")
# warning-ignore:return_value_discarded
	get_node("PassPrevShort").connect("pressed", self, "_on_pressed_pps")
# warning-ignore:return_value_discarded
	get_node("PassPrevLong").connect("pressed", self, "_on_pressed_ppl")
# warning-ignore:return_value_discarded
	get_node("Blitz").connect("pressed", self, "_on_pressed_bltz")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
