extends RigidBody3D

@onready var detL_col = $detL/CollisionShape3D
@onready var detR_col = $detR/CollisionShape3D
@onready var collision_shape_3d = $CollisionShape3D
@onready var floor_col = $floor_col/CollisionShape3D2
@onready var markR = $markR
@onready var markL = $markL
@onready var hand_mark = $hand_mark

var grabbedR = false
var holdingR = false
var grabbedL = false
var holdingL = false
var still_itemL
var still_itemR

var prev_pos = Vector3()

var disabled = false
var placed = false
var throw_point = Vector3()
var in_floor = false
var floor_bodies = 0
var throwing = false

var in_socket = false
var can_remove = false
var socket_pos = Vector3()
var socket_rot = Vector3()
var socket_id = 0

func _ready():
	throw_point = global_position

func _process(delta):
	disabled = false
	
	if grabbedR:
		get_tree().call_group("player", "_update_r_position", hand_mark.global_position, hand_mark.global_rotation)
	if grabbedL:
		get_tree().call_group("player", "_update_l_position", hand_mark.global_position, hand_mark.global_rotation)
	
	if grabbedR and not Player.r_launched:
		if in_socket:
			if can_remove:
				get_tree().call_group("player", "_hold_item_r", 1)
				in_socket = false
				holdingR = true
				grabbedR = false
		else:
			get_tree().call_group("player", "_hold_item_r", 1)
			holdingR = true
			grabbedR = false
	if holdingR and Input.is_action_just_pressed("right_hand") and not Player.right_click:
		global_position = Player.itemR_pos
		throw_point = Player.itemR_cast_point
		grabbedR = false
		holdingR = false
		throwing = true
		_drop()
	if grabbedL and not Player.l_launched:
		if in_socket:
			if can_remove:
				get_tree().call_group("player", "_hold_item_l", 1)
				in_socket = false
				holdingL = true
				grabbedL = false
		else:
			get_tree().call_group("player", "_hold_item_l", 1)
			holdingL = true
			grabbedL = false
	if holdingL and Input.is_action_just_pressed("left_hand") and not Player.left_click:
		global_position = Player.itemL_pos
		throw_point = Player.itemL_cast_point
		grabbedL = false
		holdingL = false
		throwing = true
		_drop()
	
	if holdingR:
		still_itemR = true
		disabled = true
	elif holdingL:
		still_itemL = true
		disabled = true
	else:
		if in_socket:
			global_position = socket_pos
			global_rotation = socket_rot
		elif not in_floor:
			if throwing:
				pass
	if disabled:
		detR_col.disabled = true
		detL_col.disabled = true
		collision_shape_3d.disabled = true
		floor_col.disabled = true
		visible = false
	else:
		detR_col.disabled = false
		detL_col.disabled = false
		collision_shape_3d.disabled = false
		floor_col.disabled = false
		visible = true

func _drop():
	linear_velocity = Player.item_linear_vel
	global_position = Player.item_position

func _align_socket(pos, rot, remove, id):
	socket_pos = pos
	socket_rot = rot
	can_remove = remove
	socket_id = id
	if not holdingL and not holdingR:
		in_socket = true
		return true

func _check_socket(id):
	if not in_socket and socket_id == id:
		return true
	else:
		return false

func _on_det_r_area_entered(area):
	if not in_socket:
		if Player.r_launched and not grabbedL and not holdingL:
			get_tree().call_group("player", "_set_retract_mode_r", false)
			hand_mark.global_position = area.global_position
			hand_mark.global_rotation = area.global_rotation
			grabbedR = true
	elif can_remove:
		if Player.r_launched and not grabbedL and not holdingL:
			get_tree().call_group("player", "_update_r_anim", "grab_pole")
			get_tree().call_group("player", "_set_retract_mode_r", false)
			hand_mark.global_position = markR.global_position
			hand_mark.global_rotation = markR.global_rotation
			grabbedR = true

func _on_det_l_area_entered(area):
	if not in_socket:
		if Player.l_launched and not grabbedR and not holdingR:
			get_tree().call_group("player", "_set_retract_mode_l", false)
			hand_mark.global_position = area.global_position
			hand_mark.global_rotation = area.global_rotation
			grabbedL = true
	elif can_remove:
		if Player.l_launched and not grabbedR and not holdingR:
			get_tree().call_group("player", "_update_l_anim", "grab_pole")
			get_tree().call_group("player", "_set_retract_mode_l", false)
			hand_mark.global_position = markL.global_position
			hand_mark.global_rotation = markL.global_rotation
			grabbedL = true

func _on_floor_col_body_entered(body):
	if body is CharacterBody3D or body.is_in_group("battery"):
		pass
	else:
		in_floor = true
		throwing = false
		floor_bodies += 1

func _on_floor_col_body_exited(body):
	if body is CharacterBody3D or body.is_in_group("battery"):
		pass
	else:
		floor_bodies -= 1
		if floor_bodies == 0:
			in_floor = false
		if floor_bodies < 0:
			floor_bodies = 0
