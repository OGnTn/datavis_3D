extends Camera3D

var pressed
var zoomspeed = 1
var panspeed = 0.001
var theta = 0
var phi = 0
var radius = 70
var globe_radius = 42

func _process(delta):
	look_at(Vector3.ZERO)

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("Interact"):
		set_angle_to_marker(Vector3(2.011, 32.571, 26.44))
	if event is InputEventMouseButton:
		pressed = event.pressed
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			fov = fov - zoomspeed
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			fov = fov + zoomspeed
	if event is InputEventMouseMotion:
		if pressed:
			var xMotion = event.relative.x
			var yMotion = event.relative.y
			var newTheta = theta + xMotion * panspeed
			var newPhi = phi + -yMotion * panspeed
			var angle = Vector2(newTheta, newPhi)
			set_camera_pos_angle(angle)

func set_camera_pos_angle(_angle):
	
	
	var newPos = Vector3(radius * cos(_angle.x) * sin(_angle.y), radius * cos(_angle.y), radius * sin(_angle.x) * sin(_angle.y))
	
	#tween.tween_property(self, "position", newPos, 0.5)
	position = newPos
	theta = _angle.x
	phi = _angle.y
	
func set_angle_to_marker(marker_pos: Vector3):
	print('miauw')
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	var markerTheta = atan2(marker_pos.z, marker_pos.x)
	var markerPhi = acos(marker_pos.y / globe_radius)
	var markerAngle = Vector2(markerTheta, markerPhi)
	tween.tween_method(set_camera_pos_angle, Vector2(theta,phi), markerAngle, 0.5)
	#set_camera_pos_angle(markerTheta, markerPhi)

