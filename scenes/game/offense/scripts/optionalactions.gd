extends HBoxContainer


# Declare member variables here. Examples:
onready var GAME = get_node("/root/Game")

func _on_pressed_fg():
	GAME.set_fgplay()

func _on_pressed_punt():
	GAME.set_puntplay()


func disable(on):
	for node in self.get_children():
		node.set_disabled(on)

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	get_node("FieldGoalButton").connect("pressed", self, "_on_pressed_fg")
# warning-ignore:return_value_discarded
	get_node("PuntButton").connect("pressed", self, "_on_pressed_punt")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
