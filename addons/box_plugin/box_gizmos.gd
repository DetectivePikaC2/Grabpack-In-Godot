@tool
extends EditorNode3DGizmoPlugin

var initial_size: Vector3
var initial_transform: Transform3D
var undo_redo: EditorUndoRedoManager

func _init(p_undo_redo: EditorUndoRedoManager) -> void:
	create_handle_material("handles")
	undo_redo = p_undo_redo

func _has_gizmo(for_node_3d: Node3D) -> bool:
	return for_node_3d is Box3D

func _get_gizmo_name() -> String:
	return "Box3D"

func _get_priority() -> int:
	return -1

func _get_handle_name(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> String:
	match handle_id:
		0, 1:
			return "Size X";
		2, 3:
			return "Size Y";
		4, 5:
			return "Size Z";
	return "";

func _get_handle_value(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> Variant:
	var node: Box3D = gizmo.get_node_3d()
	return node.size

func _begin_handle_action(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool) -> void:
	var node: Box3D = gizmo.get_node_3d()
	initial_size = node.size
	initial_transform = node.global_transform

func _set_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, camera: Camera3D, screen_pos: Vector2) -> void:
	var axis := handle_id / 2;
	var sign := handle_id % 2 * -2 + 1;
	var neg_end := initial_size[axis] * -0.5;
	var pos_end := initial_size[axis] * 0.5;
	var gi := initial_transform.affine_inverse()
	var ray_from := camera.project_ray_origin(screen_pos)
	var ray_dir := camera.project_ray_normal(screen_pos)
	var seg_start := gi * ray_from
	var seg_end := gi * (ray_from + ray_dir * 4096.0)
	var axis_segment_a := Vector3()
	var axis_segment_b := Vector3()
	axis_segment_a[axis] = 4096.0
	axis_segment_b[axis] = -4096.0
	var rarb := Geometry3D.get_closest_points_between_segments(axis_segment_a, axis_segment_b, seg_start, seg_end)
	var ra := rarb[0]
	var rb := rarb[1]
	var box_size := initial_size
	var box_position := initial_transform.origin
	if Input.is_key_pressed(KEY_ALT):
		box_size[axis] = ra[axis] * (sign * 2)
	else:
		box_size[axis] = ra[axis] - neg_end if sign > 0 else pos_end - ra[axis]
	if EditorInterface.is_node_3d_snap_enabled():
		box_size[axis] = snappedf(box_size[axis], EditorInterface.get_node_3d_translate_snap())
	box_size[axis] = maxf(box_size[axis], 0.001)
	if not Input.is_key_pressed(KEY_ALT):
		if sign > 0:
			pos_end = neg_end + box_size[axis]
		else:
			neg_end = pos_end - box_size[axis]
		var offset := Vector3()
		offset[axis] = (pos_end + neg_end) * 0.5
		box_position = initial_transform * offset
	var node: Box3D = gizmo.get_node_3d()
	node.size = box_size
	node.global_position = box_position
	_redraw(gizmo)

func _commit_handle(gizmo: EditorNode3DGizmo, handle_id: int, secondary: bool, restore: Variant, cancel: bool) -> void:
	var node: Box3D = gizmo.get_node_3d()
	if cancel:
		node.size = initial_size
		node.global_position = initial_transform.origin
	undo_redo.create_action("Change Box Size")
	undo_redo.add_do_property(node, &"size", node.size)
	undo_redo.add_do_property(node, &"global_position", node.global_position)
	undo_redo.add_undo_property(node, &"size", initial_size)
	undo_redo.add_undo_property(node, &"global_position", initial_transform.origin)
	undo_redo.commit_action()

func _redraw(gizmo: EditorNode3DGizmo) -> void:
	var node: Box3D = gizmo.get_node_3d()
	gizmo.clear()
	
	var handles := PackedVector3Array()
	handles.resize(6)
	handles[0] = Vector3(node.size.x * 0.5, 0.0, 0.0)
	handles[1] = Vector3(node.size.x * -0.5, 0.0, 0.0)
	handles[2] = Vector3(0.0, node.size.y * 0.5, 0.0)
	handles[3] = Vector3(0.0, node.size.y * -0.5, 0.0)
	handles[4] = Vector3(0.0, 0.0, node.size.z * 0.5)
	handles[5] = Vector3(0.0, 0.0, node.size.z * -0.5)
	gizmo.add_handles(handles, get_material("handles", gizmo), PackedInt32Array())
	gizmo.add_collision_triangles(node.mesh.generate_triangle_mesh())
