@tool
extends Node

func convert_csg() -> void:
	for child in get_children():
		if child is CSGBox3D and child.get_children().size() == 0:
			var box = Box3D.new()
			box.size = child.size
			box.material = child.material
			box.use_collision = child.use_collision
			box.transform = child.transform
			box.name = child.name
			child.replace_by(box)
			child.free()

@export_tool_button("Convert CSG's to boxes")
var convert_csg_action = convert_csg
