extends VBoxContainer

# +8 ball offset -32 half the box's total container size
const LEFT_OFFSET = 52
const PPY = 17.5  # in ball too

func set_new_position(abs_yard):
	self.margin_left = LEFT_OFFSET + (PPY * abs_yard)
	print(self.margin_left)
	get_node("Box/YardText").set_text(str(abs_yard))

# 26 = 463
