@tool
extends EditorPlugin

const MyCustomGizmoPlugin = preload("res://addons/box_plugin/box_gizmos.gd")
var gizmo_plugin

func _enter_tree() -> void:
	gizmo_plugin = MyCustomGizmoPlugin.new(get_undo_redo())
	add_node_3d_gizmo_plugin(gizmo_plugin)

func _exit_tree() -> void:
	remove_node_3d_gizmo_plugin(gizmo_plugin)
