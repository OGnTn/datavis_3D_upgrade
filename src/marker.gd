extends Node3D

var datadict
var area_scale = 3

signal focused(marker_pos)

var base_mat = load("res://assets/materials/marker_base.tres")
var highlight_mat = load("res://assets/materials/marker_highlight.tres")
var clicked_mat = load("res://assets/materials/marker_clicked.tres")


func _ready():
	$NameLabel.text = name
	#$"..".connect("unfocused", _on_unfocus)p
	pass

func _on_area_3d_mouse_entered():
	#set_color(highlighted_color)
	var mesh = $MeshInstance3D
	mesh.set_surface_override_material(0, highlight_mat)
	set_namelabel(true)
	$Area3D/CollisionShape3D.scale = Vector3(area_scale,area_scale,area_scale)

func _on_area_3d_mouse_exited():
	var mesh = $MeshInstance3D
	mesh.set_surface_override_material(0, base_mat)
	set_namelabel(false)
	$Area3D/CollisionShape3D.scale = Vector3(1,1,1)
	#set_color(base_color)
func set_color(color):

	var mesh = $MeshInstance3D
	var current_material = mesh.get_surface_override_material(0).duplicate()
	current_material = current_material.duplicate()
	current_material.albedo_color = color
	mesh.set_surface_override_material(0, current_material)

func set_namelabel(val):
	$NameLabel.visible = val

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and event.is_pressed():
			var distance_to_camera = position.distance_to(camera.position)
			if distance_to_camera < (70/2 + 21) and !camera.zooming:
				var mesh = $MeshInstance3D
				mesh.set_surface_override_material(0, clicked_mat)
				emit_signal("focused", self, position, datadict)

func _on_unfocus():

	pass
