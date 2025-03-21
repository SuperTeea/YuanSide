extends Control

var picked := false
var slot: Control = null

func return_to_slot():
	picked = false
	self.mouse_filter = MOUSE_FILTER_PASS
	if slot:
		var offset = (slot.size - self.size) / 2
		$Tween.interpolate_property(self, "position", position, slot.global_position + offset, 0.5, Tween.TRANS_EXPO, Tween.EASE_OUT)
		$Tween.start()

func _input(event):
	if event is InputEventMouseButton:
		if not event.is_pressed() and picked:
			return_to_slot()

func _process(dt):
	if picked:
		self.position = get_global_mouse_position() - (self.texture.get_size() / 2)

func _get_drag_data(_pos):
	var data = {node = self}
	print(data)
	picked = true
	self.mouse_filter = MOUSE_FILTER_IGNORE
	return data
