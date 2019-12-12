extends HBoxContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var GAME = get_node("/root/Game")

func _on_pressed_lp():
	GAME.set_offplay("Line Plunge")

func _on_pressed_offt():
	GAME.set_offplay("Off Tackle")

func _on_pressed_endr():
	GAME.set_offplay("End Run")

func _on_pressed_dr():
	GAME.set_offplay("Draw")

func _on_pressed_scr():
	GAME.set_offplay("Screen")

func _on_pressed_shrt():
	GAME.set_offplay("Short")

func _on_pressed_med():
	GAME.set_offplay("Medium")

func _on_pressed_lng():
	GAME.set_offplay("Long")

func _on_pressed_sdln():
	GAME.set_offplay("Sideline")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func disable(on):
	for node in self.get_children():
		node.set_disabled(on)

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("LinePlunge").connect("pressed", self, "_on_pressed_lp")
	get_node("OffTackle").connect("pressed", self, "_on_pressed_offt")
	get_node("EndRun").connect("pressed", self, "_on_pressed_endr")
	get_node("Draw").connect("pressed", self, "_on_pressed_dr")
	get_node("Screen").connect("pressed", self, "_on_pressed_scr")
	get_node("Short").connect("pressed", self, "_on_pressed_shrt")
	get_node("Medium").connect("pressed", self, "_on_pressed_med")
	get_node("Long").connect("pressed", self, "_on_pressed_lng")
	get_node("Sideline").connect("pressed", self, "_on_pressed_sdln")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
