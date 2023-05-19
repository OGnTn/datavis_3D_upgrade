extends Node3D

var datadict
var ranges
var area_scale = 3

signal focused(marker_pos)

var base_mat = load("res://assets/materials/marker_base.tres")
var base_mat_gradient = load("res://assets/materials/marker_base_gradient.tres")
var highlight_mat = load("res://assets/materials/marker_highlight.tres")
var clicked_mat = load("res://assets/materials/marker_clicked.tres")
var calc_mat
var average = 0
const base_scale = 0.6
const scale_offset = 0
var is_focus = false


func _ready():
	$NameLabel.text = name
	#get_node("/root/world/DataManager").connect("loaded_data", _on_data_loaded)
	
	set_namelabel(false)
	pass

func _on_data_loaded(min, max, average_all):
	for i in range(3, len(datadict.values()) - 2):
		average += float(datadict.values()[i])
	average = average/(len(datadict.values()) - 5)
	var scaled_avg_value = (average_all - min) / (max - min)
	var scaled_value = (average - min) / (max - min)
	average = scaled_value
	
	var gr: Gradient = load("res://assets/themes/bar_gradient.tres").duplicate()
	gr.set_offset(1, scaled_avg_value)
	gr.set_color(1, Color("ff584a"))
	gr.set_color(0, Color("00fd6e"))
	var mesh = $MeshInstance3D
	var newmat = mesh.get_surface_override_material(0).duplicate()
	
	var color = gr.sample(scaled_value -0.05)
	newmat.albedo_color = color
	calc_mat = newmat
	mesh.set_surface_override_material(0, newmat)
	

func _on_area_3d_mouse_entered():
	#set_color(highlighted_color)
	var mesh = $MeshInstance3D
	mesh.set_surface_override_material(0, highlight_mat)
	set_namelabel(true)
	$Area3D/CollisionShape3D.scale = Vector3(area_scale,area_scale,area_scale)

func _on_area_3d_mouse_exited():
	var mesh = $MeshInstance3D
	mesh.set_surface_override_material(0, calc_mat)
	if(!is_focus):
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
	

func _on_area_3d_input_event(camera, event, pos, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MASK_LEFT and event.is_pressed():
			var distance_to_camera = pos.distance_to(camera.position)
			if distance_to_camera < (70/2 + 21) and !camera.zooming:
				var mesh = $MeshInstance3D
				mesh.set_surface_override_material(0, clicked_mat)
				
				emit_signal("focused", self, pos, datadict)
				is_focus = true
				$Highlight.visible = true
				set_namelabel(true)

func _on_zoom(fov):
	scale = Vector3(base_scale * fov/100 + scale_offset, base_scale * fov/100 + scale_offset, base_scale * fov/100 + scale_offset)

func _on_unfocus():
	$Highlight.visible = false
	set_namelabel(false)
	is_focus = false
	pass
