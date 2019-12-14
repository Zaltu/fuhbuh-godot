extends TextureRect

const LEFT_OFFSET = 8
const PPY = 17.5

func set_new_position(abs_yard):
	self.margin_left = LEFT_OFFSET + (PPY * abs_yard)
