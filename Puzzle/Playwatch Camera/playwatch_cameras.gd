extends Node
class_name PlaywatchCams

func _ready() -> void:
	add_to_group("playcams")

func _get_next_camera(current_cam):
	var row = current_cam
	var node_path = "none"
	if get_child_count(true) > 0:
		if row > 1:
			row += 1
			node_path = str("playwatch_camera", row)
			if get_node(node_path) == null:
				node_path = str("playwatch_camera")
		else:
			node_path = str("playwatch_camera2")
		var cam_node = get_node(node_path)
		get_tree().call_group("player", "_playwatch_cam_return", cam_node.cam_number, cam_node.global_position, cam_node.global_rotation)
	else:
		assert(false, "There are no cameras in the PlaywatchCams node.")
