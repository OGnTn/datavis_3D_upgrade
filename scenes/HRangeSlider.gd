extends HSlider

class_name HRangeSlider

signal min_value_changed(value: float)
signal max_value_changed(value: float)

@export 
var min_range_value: float = 0.0 : 
	set(value):
		if value < min_value || value > max_value:
			return
		min_value = value
		emit_signal("min_value_changed", min_value)

@export 
var max__range_value: float = 1.0 : 
	set(value):
		if value > max_value || value < min_value:
			return
		max_value = value
		emit_signal("max_value_changed", max_value)

@export
var grabber_scene: PackedScene

var min_grabber: TextureRect
var max_grabber: TextureRect

func _ready():
	set_process_input(true)

	min_grabber = grabber_scene.instance()
	max_grabber = grabber_scene.instance()

	min_grabber.rect_min_size = Vector2(16, 16)
	max_grabber.rect_min_size = Vector2(16, 16)

	add_child(min_grabber)
	add_child(max_grabber)

	min_grabber.connect("gui_input",_on_min_grabber_input)
	max_grabber.connect("gui_input", _on_max_grabber_input)

	update_grabber_positions()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = get_local_mouse_position()
		if mouse_pos.x < 0:
			min_range_value = min(max_value, max_value - ((max_value - min_value) * abs(mouse_pos.x) / (10 / 2.0)))
		else:
			max__range_value = max(min_value, min_value + ((max_value - min_value) * abs(mouse_pos.x) / (10 / 2.0)))

func _on_min_grabber_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				min_grabber.modulate = Color(0.8, 0.8, 0.8)
			else:
				min_grabber.modulate = Color(1, 1, 1)

		event.handled = true

func _on_max_grabber_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				max_grabber.modulate = Color(0.8, 0.8, 0.8)
			else:
				max_grabber.modulate = Color(1, 1, 1)

		event.handled = true

func value_to_pos(value: float) -> float:
	var ratio = (value - min_value) / (max_value - min_value)
	return ratio * 10


func update_grabber_positions():
	min_grabber.rect_position.x = value_to_pos(min_value) - min_grabber.rect_min_size.x / 2.0
	max_grabber.rect_position.x = value_to_pos(max_value) - max_grabber.rect_min_size.x / 2.0

func _draw():
	update_grabber_positions()
