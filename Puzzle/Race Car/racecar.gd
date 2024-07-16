extends CharacterBody3D

@onready var markL = $model/SM_RaceCar_Ring/markL
@onready var markR = $model/SM_RaceCar_Ring/markR
@onready var anim = $AnimationPlayer
@onready var anim_wheels = $AnimationPlayer2
@onready var windup = $sfx/windup
@onready var release = $sfx/release
@onready var in_place = $sfx/in_place
@onready var drive = $sfx/drive
@onready var mini_crash = $sfx/mini_crash
@onready var wheel_smoke = $model/wheel_smoke
@onready var wheel_smoke_3 = $model/wheel_smoke3
@onready var wheel_smoke_2 = $model/wheel_smoke2
@onready var wheel_smoke_4 = $model/wheel_smoke4
@onready var fire_smoke = $model/fire_smoke
@onready var fire_smoke_2 = $model/fire_smoke2
@onready var fire = $model/fire
@onready var fire_2 = $model/fire2
@onready var crash = $sfx/crash
@onready var fire_sfx = $sfx/fire
@onready var raycast = $RayCast3D

var break_on_collision = true
var emit_fire = true

var grabbed_l = false
var grabbed_r = false
var pulling_r = false
var pulling_l = false

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 2.0
var speed = 1000.0

var pull_ready = false
var driving = false
var dead = false

func _on_det_area_entered(area):
	if Player.l_launched and not driving and not grabbed_r:
		grabbed_l = true
		get_tree().call_group("player", "_update_l_position", markL.global_position, markL.global_rotation)
		get_tree().call_group("player", "_set_retract_mode_l", false)
		get_tree().call_group("player", "_update_l_anim", "grab_pole")

func _on_det_r_area_entered(area):
	if Player.r_launched and not driving and not grabbed_l:
		grabbed_r = true
		get_tree().call_group("player", "_update_r_position", markR.global_position, markR.global_rotation)
		get_tree().call_group("player", "_set_retract_mode_r", false)
		get_tree().call_group("player", "_update_r_anim", "grab_pole")

func _process(delta):
	if grabbed_l:
		get_tree().call_group("player", "_update_l_position", markL.global_position, markL.global_rotation)
		if not Player.l_launched:
			if pull_ready:
				_release()
			else:
				release.play()
				windup.stop()
				anim.play("RESET")
			grabbed_l = false
		if Input.is_action_pressed("left_hand") and not Player.left_click:
			if not pulling_l:
				windup.play()
				anim.play("pull_string")
				pulling_l = true
		else:
			if pulling_l:
				pulling_l = false
	if grabbed_r:
		get_tree().call_group("player", "_update_r_position", markR.global_position, markR.global_rotation)
		if not Player.r_launched:
			if pull_ready:
				_release()
			else:
				release.play()
				windup.stop()
				anim.play("RESET")
			grabbed_r = false
		if Input.is_action_pressed("right_hand") and not Player.right_click:
			if not pulling_r:
				windup.play()
				anim.play("pull_string")
				pulling_r = true
		else:
			if pulling_r:
				pulling_r = false
	if dead and emit_fire:
		fire.emitting = true
		fire_2.emitting = true
		fire_smoke.emitting = true
		fire_smoke_2.emitting = true
	else:
		fire.emitting = false
		fire_2.emitting = false
		fire_smoke.emitting = false
		fire_smoke_2.emitting = false

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
	xform.basis = xform.basis.orthonormalized()
	return xform

func get_input_direction() -> Vector3:
	var input_dir = Vector3.ZERO
	input_dir.z -= 1
	return input_dir

func _physics_process(delta):
	if driving and not dead:
		if not is_on_floor():
			velocity.y -= gravity * delta
		
		var input_dir = get_input_direction()
		input_dir = input_dir.normalized()

		# Get the forward direction of the character
		var forward_dir = -transform.basis.z

		# Calculate the desired movement direction in 3D space
		var movement_dir = transform.basis.x * input_dir.x + forward_dir * input_dir.z
		movement_dir = movement_dir.normalized()

		# Move the character
		velocity.x = movement_dir.x * (speed * delta)
		velocity.z = movement_dir.z * (speed * delta)
		move_and_slide()
		var normal = raycast.get_collision_normal()
		var xform = align_with_y(global_transform, normal)
		global_transform = global_transform.interpolate_with(xform, 0.2)

func _release():
	release.play()
	in_place.stop()
	drive.play()
	anim.play("RESET")
	wheel_smoke.emitting = false
	wheel_smoke_2.emitting = false
	wheel_smoke_3.emitting = false
	wheel_smoke_4.emitting = false
	driving = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "pull_string":
		wheel_smoke_4.emitting = true
		wheel_smoke_3.emitting = true
		wheel_smoke_2.emitting = true
		wheel_smoke.emitting = true
		anim.play("pulled_loop")
		anim_wheels.play("spin_loop")
		in_place.play()
		pull_ready = true

func _on_dead_det_body_entered(body):
	if driving and not dead:
		dead = true
		anim.play("collide_end")
		crash.play()
		anim_wheels.stop()
		drive.stop()
		if emit_fire:
			fire_sfx.play()

func _on_breaker_area_entered(area):
	mini_crash.play()
