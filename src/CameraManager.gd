extends Camera3D

var pressed
var zoomspeed = 1
var panspeed = 0.001
var theta = 0
var phi = 0
var radius = 70
var globe_radius = 42
const max_fov = 90
const min_fov = 10

var zooming = false
signal moved
signal zoomed

func _ready():
	var init_angle = calc_sphere_angle(position, radius)
	theta = init_angle.x
	phi = init_angle.y
	$"..".connect("unfocused", _on_unfocus)

func _process(_delta):
	if zooming:
		emit_signal("zoomed")
	
	look_at(Vector3.ZERO)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Interact") and $Timer.is_stopped():
		set_angle_to_marker(Vector3(2.011, 32.571, 26.44))
		$Timer.start()
	if event is InputEventMouseButton:
		pressed = event.pressed
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if(fov > min_fov):
				fov = fov - zoomspeed
				emit_signal("zoomed")
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if(fov < max_fov):
				fov = fov + zoomspeed
				emit_signal("zoomed")
	if event is InputEventMouseMotion:
		if pressed and $Timer.is_stopped():
			emit_signal("moved")
			if $"..".dragging_slider == false:
				var xMotion = event.relative.x
				var yMotion = event.relative.y
				var newTheta = fmod(theta + xMotion * panspeed, 2* PI)
				var newPhi = fmod(phi + -yMotion * panspeed, 2 * PI)
				var angle = Vector2(newTheta, newPhi)
				set_camera_pos_angle(angle)
				

func emit_zoomed():
	emit_signal("zoomed")

func set_camera_pos_angle(_angle):
	position = calc_sphere_pos(_angle)
	theta = _angle.x
	phi = _angle.y
	
func calc_sphere_pos(_angle):
		var newPos = Vector3(radius * cos(_angle.x) * sin(_angle.y), radius * cos(_angle.y), radius * sin(_angle.x) * sin(_angle.y))
		return newPos
func calc_sphere_angle(_pos, _radius):
	var _theta = atan2(_pos.z, _pos.x)
	var _phi = acos(_pos.y / _radius)
	return Vector2(_theta, _phi)

func set_angle_to_marker(marker_pos: Vector3):
	emit_signal("moved")
	$Timer.start()
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	var markerAngle = calc_sphere_angle(marker_pos, globe_radius)
	tween.tween_method(set_camera_pos_angle, Vector2(theta, phi), markerAngle, 0.5)
	smooth_zoom(40)

func smooth_zoom(_fov):
	
	zooming = true
	var tween = create_tween()
	tween.finished.connect(_on_zoom_finished)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "fov", _fov, 0.7)
	
	
	
func _on_zoom_finished():
	zooming = false

func _on_unfocus():
	smooth_zoom(85)
