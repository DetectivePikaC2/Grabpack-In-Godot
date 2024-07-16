extends StaticBody3D

@onready var hit = $hit
@onready var fly = $fly

func _on_hand_collision_area_entered(area):
	if Player.current_hand == 5 and Player.r_launched:
		_pull_player()

func _pull_player():
	var point = global_position
	hit.play()
	point.y -= 1
	Player.is_dashing = true
	get_tree().call_group("player", "_set_retract_mode_r", false)
	get_tree().call_group("player", "_pull_towards_point", point, 30, true)
