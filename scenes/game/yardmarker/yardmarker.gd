extends VBoxContainer

const LEFT_OFFSET = 52
const PPY = 17.5  # in ball too

func set_new_position(abs_yard, yard):
	self.margin_left = LEFT_OFFSET + (PPY * abs_yard)
	get_node("Box/YardText").set_text(str(yard))
