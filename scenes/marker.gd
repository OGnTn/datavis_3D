extends Node3D
@onready
var base_color = $MeshInstance3D.get_surface_override_material(0).albedo_color
var highlighted_color = Color(1,1,1,1)
var clicked_color = Color("GREEN")
signal focused(marker_pos)


func _on_area_3d_mouse_entered():
	set_color(highlighted_color)


func _on_area_3d_mouse_exited():
	set_color(base_color)
func set_color(color):
	var mesh = $MeshInstance3D
	var current_material = mesh.get_surface_override_material(0)
	current_material.albedo_color = color
	mesh.set_surface_override_material(0, current_material)


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			set_color(clicked_color)
			emit_signal("focused", position)
