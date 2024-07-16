extends StaticBody3D

@onready var cast = $PuzzlePole_Base/rotating/PuzzlePole_UpperFlap/RayCast3D
@onready var marker_3d = $PuzzlePole_Base/rotating/PuzzlePole_LowerFlap/Marker3D
@onready var anim = $PuzzlePole_Base/anim
@onready var line = $PuzzlePole_Base/rotating/PuzzlePole_LowerFlap/line
@onready var hand_cast = $PuzzlePole_Base/rotating/PuzzlePole_UpperFlap/hand_cast

var using = false
var ray_point = Vector3()
var has_hit = false

func _process(delta):
	if not ray_point == Vector3.ZERO:
		line.visible = true
		hand_cast.target_position.x = line.global_position.distance_to(ray_point) / 2
		if hand_cast.is_colliding() and not has_hit:
			line.scale.x = line.global_position.distance_to(Player.r_pos) / 2
		else:
			line.scale.x = line.global_position.distance_to(ray_point) / 2
			has_hit = true
	else:
		line.visible = false
	if using:
		get_tree().call_group("player", "_update_r_position", marker_3d.global_position, marker_3d.global_rotation)

func _on_anim_animation_finished(anim_name):
	if anim_name == "hit":
		ray_point = cast.get_collision_point()
		get_tree().call_group("player", "_update_r_position", cast.get_collision_point(), marker_3d.global_rotation)
		using = false
		has_hit = false

func _on_hand_r_area_entered(area):
	if not using:
		get_tree().call_group("player", "_set_retract_mode_r", false)
		anim.play("hit")
		Player.rotating_pillar = true
		using = true

func _input(event):
	if Input.is_action_pressed("jump"):
		Player.rotating_pillar = false
		ray_point = Vector3.ZERO
		anim.play("RESET")
