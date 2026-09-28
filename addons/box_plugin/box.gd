@tool
class_name Box3D
extends GeometryInstance3D

@export var size: Vector3 = Vector3(1.0, 1.0, 1.0):
	set(new_size):
		size = new_size
		if mesh:
			mesh.size = new_size
		if shape:
			shape.size = new_size
@export var material: Material:
	set(new_material):
		material = new_material
		if mesh:
			mesh.material = new_material
@export var use_collision: bool = true:
	set(new_use_collision):
		use_collision = new_use_collision
		if use_collision:
			if is_inside_tree() and not collision.is_valid():
				shape = BoxShape3D.new()
				shape.size = size
				_create_collision()
		else:
			if collision.is_valid():
				PhysicsServer3D.free_rid(collision)
				collision = RID()
				shape = null

var mesh: BoxMesh
var shape: BoxShape3D
var collision: RID

func _get_aabb() -> AABB:
	return mesh.get_aabb()

func _create_collision() -> void:
	collision = PhysicsServer3D.body_create()
	PhysicsServer3D.body_set_mode(collision, PhysicsServer3D.BODY_MODE_STATIC)
	PhysicsServer3D.body_set_state(collision, PhysicsServer3D.BODY_STATE_TRANSFORM, global_transform)
	PhysicsServer3D.body_add_shape(collision, shape.get_rid())
	PhysicsServer3D.body_set_space(collision, get_world_3d().space)
	PhysicsServer3D.body_attach_object_instance_id(collision, get_instance_id())

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_ENTER_TREE:
			if use_collision:
				shape = BoxShape3D.new()
				shape.size = size
				_create_collision()
			mesh = BoxMesh.new()
			mesh.size = size
			mesh.material = material
			set_base(mesh.get_rid())
		NOTIFICATION_EXIT_TREE:
			if collision.is_valid():
				PhysicsServer3D.free_rid(collision)
			collision = RID()
			shape = null
			mesh = null
		NOTIFICATION_TRANSFORM_CHANGED:
			if collision.is_valid():
				PhysicsServer3D.body_set_state(collision, PhysicsServer3D.BODY_STATE_TRANSFORM, global_transform)
