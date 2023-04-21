extends Node3D
var city_marker_file = preload("res://scenes/marker.tscn")
@onready
var earth = $earth_scene
var globe_radius = 42

# Called when the node enters the scene tree for the first time.
func _ready():
	add_marker(50.85045, 4.34878)
	add_marker(40.730610, -73.935242)
	
	pass # Replace with function body.

func add_marker(latitude, longitude):
	var city_marker = city_marker_file.instantiate()
	earth.add_child(city_marker)
	city_marker.connect("focused", _on_marker_focused)
	var position = lat_lon_to_3d(latitude, longitude, globe_radius)
	city_marker.transform.origin = position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func lat_lon_to_3d(latitude_degrees: float, longitude_degrees: float, radius: float) -> Vector3:
	var latitude = deg_to_rad(latitude_degrees)
	var longitude = deg_to_rad(longitude_degrees)
	var x = radius * cos(latitude) * sin(longitude)
	var y = radius * sin(latitude)
	var z = radius * cos(latitude) * cos(longitude)
	return Vector3(x, y, z)
	
func _on_marker_focused(marker_pos: Vector3):
	$Camera3D.set_angle_to_marker(marker_pos)

