@tool
extends Node3D
class_name DraggableObject3D

@export var pull_speed = 0.001

var area3d: Area3D
var collision:CollisionShape3D
var marker: Marker3D
var marker2: Marker3D

var grabbed_l = false
var grabbed_r = false

@onready var object = get_parent()
@onready var area_3d: Area3D = $Area3D
@onready var collision_shape_3d: CollisionShape3D = $Area3D/CollisionShape3D
@onready var marker_3d: Marker3D = $Marker3D
@onready var marker_3d_2 = $Marker3D2

func _ready():
	area_3d.area_entered.connect(Callable(self,"_hand_collided"))

func _physics_process(delta: float) -> void:
	if grabbed_l and Input.is_action_pressed("left_hand") and not Player.left_click:
		var direction: Vector3 = (Player.player_position - object.global_transform.origin).normalized()
		object.apply_impulse(direction, direction * pull_speed)
	
	if grabbed_r and Input.is_action_pressed("right_hand") and not Player.right_click:
		var direction: Vector3 = (Player.player_position - object.global_transform.origin).normalized()
		object.apply_impulse(direction, direction * pull_speed)

func _process(delta: float) -> void:
	if grabbed_l:
		get_tree().call_group("player", "_update_l_position", marker_3d.global_position, marker_3d.global_rotation)
		if not Player.l_launched:
			grabbed_l = false
	if grabbed_r:
		get_tree().call_group("player", "_update_r_position", marker_3d_2.global_position, marker_3d_2.global_rotation)
		if not Player.r_launched:
			grabbed_r = false

func _enter_tree() -> void:
	if get_node("Area3D") == null:
		area3d = Area3D.new()
		collision = CollisionShape3D.new()
		marker = Marker3D.new()
		marker2 = Marker3D.new()
		add_child(area3d)
		add_child(marker)
		add_child(marker2)
		area3d.set_collision_layer_value(1,false)
		area3d.set_collision_layer_value(4,true)
		area3d.set_collision_layer_value(5,true)
		area3d.set_collision_mask_value(1,false)
		area3d.set_collision_mask_value(4,true)
		area3d.set_collision_mask_value(5,true)
		area3d.add_child(collision)
		area3d.set_owner(get_tree().edited_scene_root)
		collision.set_owner(get_tree().edited_scene_root)
		marker.set_owner(get_tree().edited_scene_root)
		marker2.set_owner(get_tree().edited_scene_root)
		area3d.name = "Area3D"
		collision.name = "CollisionShape3D"
		marker.name = "Marker3D"
		marker2.name = "Marker3D2"
		print(get_children())

func _hand_collided(area: Area3D) -> void:
	if area.collision_layer == 8:
		if not grabbed_l and Player.l_launched:
			get_tree().call_group("player", "_set_retract_mode_l", false)
			marker_3d.global_position = area.global_position
			marker_3d.global_rotation = area.global_rotation
			grabbed_l = true
	if area.collision_layer == 16:
		if not grabbed_r and Player.r_launched:
			get_tree().call_group("player", "_set_retract_mode_r", false)
			marker_3d_2.global_position = area.global_position
			marker_3d_2.global_rotation = area.global_rotation
			grabbed_r = true
