extends HBoxContainer

func _on_h_slider_value_changed(value):
	$InfoValue.text = str(value)
