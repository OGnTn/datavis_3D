extends Node3D
var city_marker_file = preload("res://scenes/marker.tscn")
var info_label_file = preload("res://scenes/info_container.tscn")
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


@onready
var info_panel = $UI/InfoPanel

# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera3D.connect("moved", _on_camera_moved)
	for i in range(len(keys) - 5):
		var info_label = info_label_file.instantiate()
		$UI/InfoPanel/CostContainer/CostPanel.add_child(info_label)
		var filter_container = filter_container_file.instantiate()
		$UI/FilterPanel/FilterContainer.add_child(filter_container)
		
	set_filter_ui()

func add_marker(latitude, longitude, datadict):
	var city_marker = city_marker_file.instantiate()
	city_marker.datadict = datadict
	city_marker.connect("focused", _on_marker_focused)
	if(latitude != null and longitude != null):
		var position = lat_lon_to_3d(float(latitude), float(longitude), globe_radius)
		city_marker.transform.origin = position
		city_marker.name = datadict.get("city")
		$earth_scene.add_child(city_marker)
		markers[city_marker.name] = city_marker

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func set_filter_ui():
	for i in range(3, len(keys) - 2):
		filter_containers[keys[i]] = $UI/FilterPanel/FilterContainer.get_children()[i-3]
		var filter_container_children = filter_containers[keys[i]].get_children()
		filter_container_children[0].text = keys[i]
		var slider:HSlider = filter_container_children[2]
		slider.max_value = ranges[keys[i]][0]
		slider.min_value = ranges[keys[i]][1]
		slider.connect("value_changed", _on_slider_value_changed)
		slider.connect("drag_started", _on_slider_drag_start)
		slider.connect("drag_ended", _on_slider_drag_stop)

func _on_slider_drag_start():
	dragging_slider = true
func _on_slider_drag_stop(val):
	dragging_slider = false

func _on_slider_value_changed(val):
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
	set_marker_ui(datadict)
	state = state_set.FOCUSED
func _on_camera_moved():
	if state == state_set.FOCUSED:
		info_panel.visible = false
		$UI/FilterPanel.visible = true
		state = state_set.UNFOCUSED
		current_marker.set_namelabel(false)
		emit_signal("unfocused")
		
func set_marker_ui(dict: Dictionary):
	$UI/InfoPanel/NamePanel/CityLabel.text = dict['city']
	$UI/InfoPanel/NamePanel/CountryLabel.text = dict['country']
	$UI/FilterPanel.visible = false
	var containers = $UI/InfoPanel/CostContainer/CostPanel.get_children()
	for i in range(1, len(containers)):
		var value = dict.values()[i + 2]
		var key = dict.keys()[i+2]
		var labels = containers[i].get_children()
		labels[0].text = key
		labels[1].text = value

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
