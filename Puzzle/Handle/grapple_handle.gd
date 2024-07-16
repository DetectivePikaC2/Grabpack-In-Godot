extends StaticBody3D

@onready var l_marker = $markL
@onready var r_marker = $markR
@onready var player_mark = $player_mark

var grabbed_l = false
var grabbed_r = false
var pulling_r = false
var pulling_l = false

func _on_det_area_entered(area):
	if Player.l_launched:
		grabbed_l = true
		get_tree().call_group("player", "_update_l_position", l_marker.global_position, l_marker.global_rotation)
		get_tree().call_group("player", "_set_retract_mode_l", false)
		get_tree().call_group("player", "_update_l_anim", "grab_pole")

func _on_det_r_area_entered(area):
	if Player.r_launched:
		grabbed_r = true
		get_tree().call_group("player", "_update_r_position", r_marker.global_position, r_marker.global_rotation)
		get_tree().call_group("player", "_set_retract_mode_r", false)
		get_tree().call_group("player", "_update_r_anim", "grab_pole")

func _process(delta):
	if grabbed_l:
		if not Player.l_launched:
			get_tree().call_group("player", "_cancel_pull")
			grabbed_l = false
		if Input.is_action_pressed("left_hand") and not Player.left_click:
			if not pulling_l:
				get_tree().call_group("player", "_pull_towards_point", player_mark.global_position, 5, false)
				pulling_l = true
		else:
			if pulling_l:
				pulling_l = false
	if grabbed_r:
		if not Player.r_launched:
			get_tree().call_group("player", "_cancel_pull")
			grabbed_r = false
		if Input.is_action_pressed("right_hand") and not Player.right_click:
			if not pulling_r:
				get_tree().call_group("player", "_pull_towards_point", player_mark.global_position, 5, false)
				pulling_r = true
		else:
			if pulling_r:
				pulling_r = false
