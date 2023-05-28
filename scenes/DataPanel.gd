extends Panel


# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../Camera3D".connect("moved", _on_moved)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_close_data_panel_button_pressed():
	visible = false


func _on_data_panel_button_pressed():
	visible = !visible

func _on_moved():
	visible = false
