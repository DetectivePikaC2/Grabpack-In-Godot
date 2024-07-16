@tool
extends StaticBody3D

enum levers {
	Lever,
	Switch
}

@export_category("Settings")
##Which lever type the lever is
@export var lever_type: levers = levers.Lever

@export_category("Settings")
##If enabled, the lever does nothing when flipped. Can be changed while the game is running.
@export var unavailable = false

@onready var markL = $RootNode/lever/marks/markL
@onready var markL2 = $RootNode/lever/marks/markL2
@onready var markR = $RootNode/lever/marks/markR
@onready var markR2 = $RootNode/lever/marks/markR2
@onready var fail_time = $fail_time
@onready var marks = $RootNode/lever/marks
@onready var switch_base = $RootNode/SM_Switch_A_mo
@onready var switch_handle = $RootNode/lever/SM_Switch_A_Lever_mo
@onready var lever_base = $RootNode/lever_base
@onready var lever_handle = $RootNode/lever/lever_dummy_material_0_001_0
@onready var anim = $AnimationPlayer
@onready var lever_detL = $RootNode/lever/areaL/CollisionShape3D
@onready var switch_detL = $RootNode/lever/areaL/CollisionShape3D2
@onready var lever_detR = $RootNode/lever/areaR/CollisionShape3D
@onready var switch_detR = $RootNode/lever/areaR/CollisionShape3D2
@onready var lever_col = $RootNode/lever/CollisionShape3D
@onready var switch_col = $RootNode/lever/CollisionShape3D2

var status = false
var grabbedL = false
var pullingL = false
var used_markerL = false
var queue_changeL = false
var grabbedR = false
var pullingR = false
var used_markerR = false
var queue_changeR = false
var prev_lever

signal pulled(direction)

func _ready():
	if lever_type == 0:
		switch_detL.disabled = true
		switch_detR.disabled = true
		switch_col.disabled = true
		marks.position = Vector3(0.0, -0.989, 0.001)
	else:
		lever_detL.disabled = true
		lever_detR.disabled = true
		lever_col.disabled = true
		marks.position = Vector3(0.0, -0.559, 0.006)

func _set_type(type):
	switch_base.visible = false
	switch_handle.visible = false
	lever_base.visible = false
	lever_handle.visible = false
	if type == 0:
		lever_base.visible = true
		lever_handle.visible = true
	if type == 1:
		switch_base.visible = true
		switch_handle.visible = true

func _process(delta):
	if grabbedL:
		if Input.is_action_just_pressed("left_hand") and not pullingL:
			_pull_sfx()
			if not unavailable:
				if status:
					anim.play_backwards("flip")
					status = false
					emit_signal("pulled", false)
				else:
					anim.play("flip")
					status = true
					emit_signal("pulled", true)
			else:
				fail_time.start()
				if status:
					anim.play_backwards("fail")
				else:
					anim.play("fail")
			pullingL = true
		if Player.l_launched:
			if used_markerL:
				get_tree().call_group("player", "_update_l_position", markL2.global_position, markL2.global_rotation)
			else:
				get_tree().call_group("player", "_update_l_position", markL.global_position, markL.global_rotation)
		if not Player.l_launched:
			grabbedL = false
			pullingL = false
	if grabbedR:
		if Input.is_action_just_pressed("right_hand") and not pullingR:
			_pull_sfx()
			if not unavailable:
				if status:
					anim.play_backwards("flip")
					status = false
					emit_signal("pulled", false)
				else:
					anim.play("flip")
					status = true
					emit_signal("pulled", true)
			else:
				fail_time.start()
				if status:
					anim.play_backwards("fail")
				else:
					anim.play("fail")
			pullingR = true
		if Player.r_launched:
			if used_markerR:
				get_tree().call_group("player", "_update_r_position", markR2.global_position, markR2.global_rotation)
			else:
				get_tree().call_group("player", "_update_r_position", markR.global_position, markR.global_rotation)
		if not Player.r_launched:
			grabbedR = false
			pullingR = false
	if not prev_lever == lever_type:
		_set_type(lever_type)
	prev_lever = lever_type

func _pull_sfx():
	var path = str("pull", randi_range(1, 3))
	var node = get_node(path)
	node.play()

func _on_area_l_area_entered(area):
	if not grabbedL and not grabbedR and Player.l_launched:
		if queue_changeL:
			used_markerL = status
			queue_changeL = false
		get_tree().call_group("player", "_update_l_anim", "grab_pole")
		get_tree().call_group("player", "_set_retract_mode_l", false)
		grabbedL = true

func _on_area_r_area_entered(area):
	if not grabbedR and not grabbedL and Player.r_launched:
		if queue_changeR:
			used_markerR = status
			queue_changeR = false
		get_tree().call_group("player", "_update_r_anim", "grab_pole")
		get_tree().call_group("player", "_set_retract_mode_r", false)
		grabbedR = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "flip":
		queue_changeL = true
		queue_changeR = true
		pullingL = false
		pullingR = false
	if anim_name == "fail":
		pullingL = false
		pullingR = false

func _on_fail_time_timeout():
	_pull_sfx()
