extends Camera3D

var drag_start: Vector2 = Vector2.ZERO
var rotation_speed: float = 0.001
var center: Vector3 = Vector3.ZERO
var radius: float = 10000.0
var theta: float = 0.0
var phi: float = 0.0
var zoomspeed = 1
var pressed
@onready
var earth: Node3D = $"../earth_scene"

func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
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
			
			earth.global_transform = earth.global_transform.rotated(Vector3.UP, xMotion * rotation_speed)
			earth.global_transform = earth.global_transform.rotated(Vector3.BACK, -yMotion * rotation_speed)
			
			#var global_rotation = earth.global_transform.basis.get_rotation_quaternion()
			#var new_global_rotation = Quaternion(0, global_rotation.y + xMotion * rotation_speed, global_rotation.z + yMotion * rotation_speed, global_rotation.w)
			#earth.global_transform.basis = Basis(new_global_rotation)
			
			#earth.rotate(Vector3.UP,xMotion * rotation_speed)
			#earth.rotate(Vector3.BACK,-yMotion * rotation_speed)
			
			print(earth.rotation_degrees)
			print(earth.global_rotation_degrees)

			
	pass

func update_transform() -> void:
	pass
