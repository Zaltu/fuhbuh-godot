extends VBoxContainer


func disable(on):
	get_node("OffenseButtons").disable(on)
	get_node("OptionalActions").disable(on)
