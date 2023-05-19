extends Node3D
var city_marker_file = preload("res://scenes/marker.tscn")
var info_label_file = preload("res://scenes/info_container_bar.tscn")
var filter_container_file = preload("res://scenes/filter_container.tscn")
#var earth = $earth_scene
var globe_radius = 42.5

enum state_set {FOCUSED, UNFOCUSED}
var state = state_set.UNFOCUSED
signal unfocused
var current_marker

var markers = {}
var keys
var ranges
var filter_containers = {}
var dragging_slider = false
signal zoomed_globe

@onready
var info_panel = $UI/InfoPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera3D.connect("moved", _on_camera_moved)
	for i in range(3,len(keys) - 2):
		var info_label = info_label_file.instantiate()
		$UI/InfoPanel/CostContainer/CostPanel.add_child(info_label)
		var filter_container = filter_container_file.instantiate()
		$UI/FilterPanel/FilterContainer.add_child(filter_container)
		
	set_filter_ui()

func add_marker(latitude, longitude, datadict):
	var city_marker = city_marker_file.instantiate()
	city_marker.datadict = datadict
	city_marker.ranges = ranges
	city_marker.connect("focused", _on_marker_focused)
	connect("unfocused", city_marker._on_unfocus)
	connect("zoomed_globe", city_marker._on_zoom)
	if(latitude != null and longitude != null):
		var pos = lat_lon_to_3d(float(latitude), float(longitude), globe_radius)
		city_marker.transform.origin = pos
		city_marker.name = datadict.get("city")
		$earth_scene.add_child(city_marker)
		markers[city_marker.name] = city_marker
	
	return city_marker
	
func set_filter_ui():
	for i in range(3, len(keys) - 2):
		filter_containers[keys[i]] = $UI/FilterPanel/FilterContainer.get_children()[i-3]
		var filter_container_children = filter_containers[keys[i]].get_children()
		filter_container_children[0].text = Globals.names[keys[i]]
		var slider:HSlider = filter_container_children[2]
		slider.max_value = ranges[keys[i]][0]
		slider.min_value = ranges[keys[i]][1]
		slider.connect("value_changed", _on_slider_value_changed)
		slider.connect("drag_started", _on_slider_drag_start)
		slider.connect("drag_ended", _on_slider_drag_stop)

func _on_slider_drag_start():
	dragging_slider = true
func _on_slider_drag_stop(_val):
	dragging_slider = false

func _on_slider_value_changed(_val):
	var new_filter = {}
	for filter_container in filter_containers:
		var slider = filter_containers[filter_container].get_children()[2]
		new_filter[filter_container] = slider.value
	set_filter(new_filter)

func lat_lon_to_3d(latitude_degrees: float, longitude_degrees: float, radius: float) -> Vector3:
	var latitude = deg_to_rad(latitude_degrees)
	var longitude = deg_to_rad(longitude_degrees)
	var x = radius * cos(latitude) * sin(longitude)
	var y = radius * sin(latitude)
	var z = radius * cos(latitude) * cos(longitude)
	return Vector3(x, y, z)
	
func _on_marker_focused(marker: Node3D, marker_pos: Vector3, datadict: Dictionary):
	$Camera3D.set_angle_to_marker(marker_pos)
	info_panel.visible = true
	current_marker = marker
	marker.set_namelabel(true)
	set_marker_ui(datadict, marker)
	state = state_set.FOCUSED
func _on_camera_moved():
	if state == state_set.FOCUSED:
		info_panel.visible = false
		$UI/FilterPanel.visible = true
		state = state_set.UNFOCUSED
		current_marker.set_namelabel(false)
		emit_signal("unfocused")
		
func set_marker_ui(dict: Dictionary, _marker):
	$UI/InfoPanel/NamePanel/CityLabel.text = dict['city']
	$UI/InfoPanel/NamePanel/CountryLabel.text = dict['country']
	$UI/FilterPanel.visible = false
	var containers = $UI/InfoPanel/CostContainer/CostPanel.get_children()
	for i in range(3, len(containers) + 2):
		var value = dict.values()[i]
		var key = dict.keys()[i]
		var labels = containers[i - 2].get_children()[0].get_children()
		var bar = containers[i - 2].get_children()[1].get_children()[0]
		var bar_avg:ProgressBar = containers[i - 2].get_children()[1].get_children()[1]
		var labelcontainer = containers[i - 2].get_children()[0]
		containers[i - 2].tooltip_text = Globals.descriptions[dict.keys()[i]]
		
		
		bar.max_value = ranges[key][0]
		bar.min_value = ranges[key][1]
		bar.value = float(value)
		
		var stylebox: StyleBoxFlat = bar.get("theme_override_styles/fill").duplicate()
		bar.set("theme_override_styles/fill", stylebox)
		
		var val = float(value)
		var min_value = ranges[key][1]
		var max_value = ranges[key][0]
		var avg_value = ranges[key][2]
		
		var scaled_avg_value = (avg_value - min_value) / (max_value - min_value)
		var scaled_value = (val - min_value) / (max_value - min_value)
		
		var gr: Gradient = load("res://assets/themes/bar_gradient.tres")
		gr.set_offset(1, scaled_avg_value)
		stylebox.bg_color = gr.sample(scaled_value)
		
		bar_avg.max_value = ranges[key][0]
		bar_avg.min_value = ranges[key][1]
		bar_avg.value = ranges[key][2]
		
		labels[0].text = Globals.names[key]
		labels[1].text = value

func calculate_lerp(min_val, max_val, avg_val, val):
	var v = 2 * (val - avg_val) /(max_val - min_val) + 1
	return (v + 1)/2

func set_filter(filter_dict: Dictionary):
	for marker in markers:
		var filtered = false
		for filter in filter_dict:
			#print(markers[marker].name)
			#print(markers[marker].datadict[filter])
			#print(float(filter_dict[filter]))
			var marker_value = abs(float(markers[marker].datadict[filter]))
			var filter_value = abs(float(filter_dict[filter]))
			if marker_value < filter_value:
				#print("Marker: " + markers[marker].name + "disabled")
				markers[marker].visible = false
				filtered = true
		if !filtered:
			markers[marker].visible = true

func reset_filter():
	for marker in markers:
		markers[marker].visible = true


func _on_camera_3d_zoomed():
	emit_signal("zoomed_globe", $Camera3D.fov)
