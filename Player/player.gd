extends CharacterBody3D

@onready var ball_scene = preload("res://Player/flare.tscn")

@export_category("Settings")
@export var use_mobile_controls = false
@export_subgroup("Movement")
@export var JUMP_VELOCITY = 7
@export var WALKING_SPEED = 5.0
@export var SPRINTING_SPEED = 8.0
@export var CROUCHING_SPEED = 3.0
@export var CROUCHING_DEPTH = -0.9
@export var MOUSE_SENS = 0.1
@export var LERP_SPEED = 10.0
@export var AIR_LERP_SPEED = 6.0
@export var FREE_LOOK_TILT_AMOUNT = 5.0
@export var SLIDING_SPEED = 5.0
@export var WIGGLE_ON_WALKING_SPEED = 18.0
@export var WIGGLE_ON_SPRINTING_SPEED = 24.0
@export var WIGGLE_ON_CROUCHING_SPEED = 10.0
@export var WIGGLE_ON_WALKING_INTENSITY = 0.06
@export var WIGGLE_ON_SPRINTING_INTENSITY = 0.06
@export var WIGGLE_ON_CROUCHING_INTENSITY = 0.05
@export var BUNNY_HOP_ACCELERATION = 0.1

#grabpack vars:
@export_category("Player")

##If enabled, the player starts with a grabpack
@export var start_with_grabpack = true
##If enabled, the player starts with a gas mask
@export var start_with_gas_mask = false
enum grab_version {
	Grabpack1,
	Grabpack2,
}
##Which version of the Grabpack the player starts with if start_with_grabpack is enabled.
@export var grabpack_version: grab_version = grab_version.Grabpack1
##If enabled, the player has a flashlight. This value can be changed while the game is being played.
@export var has_flashlight = false
##If enabled, the flashlight will flicker
@export var flashlight_flicker = false

@export_subgroup("Grabpack 1.0")

enum start_hand {
	None,
	Red,
	Green,
	Rocket,
	Flare,
	Dash,
}
##The hand that the Player starts with if using the Grabpack 1.0
@export var starting_hand: start_hand = start_hand.Red

#onreadys:

@onready var neck = $neck
@onready var head = $neck/head
@onready var eyes = $neck/head/eyes
@onready var camera = $neck/head/eyes/Camera
@onready var ray_cast_3d = $RayCast3D
@onready var standing_collision = $Standing_Collision
@onready var crouch_collision = $Crouch_Collision
@onready var slide_timer = $slide_timer
@onready var animation_player = $neck/head/eyes/AnimationPlayer
@onready var grabpack_1 = $neck/head/grabpack_1
@onready var r_hand = $neck/head/grabpack_1/scale/pack_nodes/RHand
@onready var l_hand = $neck/head/grabpack_1/scale/pack_nodes/LHand
@onready var l_hand_pos = $neck/head/grabpack_1/scale/pack_nodes/l_hand
@onready var line_l = $pack_lines/line_l/line_l_main
@onready var line_l_pos = $neck/head/grabpack_1/scale/pack_nodes/l_line
@onready var l_anim = $neck/head/grabpack_1/scale/pack_nodes/LHand/l_anim
@onready var line_cast = $pack_lines/line_l/line_l_main/line_cast
@onready var line_l_sub_1 = $pack_lines/line_l/line_l_sub1
@onready var line_l_sub_2 = $pack_lines/line_l/line_l_sub2
@onready var line_l_sub_3 = $pack_lines/line_l/line_l_sub3
@onready var hand_l_marker = $neck/head/grabpack_1/scale/pack_nodes/LHand/hand_l_marker
@onready var pack_playerl = $neck/head/grabpack_1/scale/pack_nodes/Grabpack/pack_playerl
@onready var r_line_cast = $pack_lines/line_r/line_r_main/line_cast
@onready var line_r_sub_1 = $pack_lines/line_r/line_r_sub1
@onready var line_r_sub_2 = $pack_lines/line_r/line_r_sub2
@onready var line_r_sub_3 = $pack_lines/line_r/line_r_sub3
@onready var line_r = $pack_lines/line_r/line_r_main
@onready var r_line_pos = $neck/head/grabpack_1/scale/pack_nodes/r_line
@onready var r_hand_marker = $neck/head/grabpack_1/scale/pack_nodes/RHand/hand_r_marker
@onready var r_hand_pos = $neck/head/grabpack_1/scale/pack_nodes/r_hand
@onready var extra_anim = $neck/head/grabpack_1/extra_anim
@onready var r_anim = $neck/head/grabpack_1/scale/pack_nodes/RHand/r_anim
@onready var pack_player_r = $neck/head/grabpack_1/scale/pack_nodes/Grabpack/pack_player_r
@onready var line_mesh = $pack_lines/line_l/line_l_main/MeshInstance3D
@onready var r_main_col = $neck/head/grabpack_1/scale/pack_nodes/RHand/hand/CollisionShape3D
@onready var l_main_col = $neck/head/grabpack_1/scale/pack_nodes/LHand/hand/CollisionShape3D
@onready var hand_l_col = $neck/head/grabpack_1/scale/pack_nodes/LHand/hand_Lcol/CollisionShape3D
@onready var hand_r_col = $neck/head/grabpack_1/scale/pack_nodes/LHand/hand/CollisionShape3D
@onready var grabpack = $neck/head/grabpack_1/scale/pack_nodes/Grabpack
@onready var new_grabpack = $neck/head/grabpack_1/scale/pack_nodes/NewGrabpack
@onready var new_pack_anim = $neck/head/grabpack_1/scale/pack_nodes/NewGrabpack/new_pack_anim
@onready var flashlight = $neck/head/grabpack_1/scale/pack_nodes/Flashlight
@onready var flash_right_pos = $neck/head/grabpack_1/scale/pack_nodes/flash_right_pos
@onready var switch_timer = $neck/head/grabpack_1/scale/pack_nodes/NewGrabpack/switch_timer
@onready var pack_switch_timer = $neck/head/grabpack_1/pack_switch_timer
@onready var flash = $neck/head/grabpack_1/scale/pack_nodes/Flashlight/flash
@onready var battery_pos_r = $neck/head/grabpack_1/scale/pack_nodes/battery_pos_r
@onready var pack_defualt = $neck/head/pack_defualt
@onready var pack_forward = $neck/head/pack_forward
@onready var pack_left = $neck/head/pack_left
@onready var pack_right = $neck/head/pack_right
@onready var pack_backwards = $neck/head/pack_backwards
@onready var cross_flare = $ui/crosshair/flare
@onready var cross_normal = $ui/crosshair/normal
@onready var swing_timer = $neck/head/grabpack_1/sfx/swing_timer
@onready var hand_switch_timer = $neck/head/grabpack_1/hand_switch_timer
@onready var crouch_enter = $neck/head/grabpack_1/crouch_enter
@onready var crouch_exit = $neck/head/grabpack_1/crouch_exit
@onready var crosshair = $ui/crosshair
@onready var pack_nodes = $neck/head/grabpack_1/scale/pack_nodes
@onready var ui_anim = $ui/ui_anim
@onready var damage_anim = $ui/damage_anim
@onready var pack_full_timer = $neck/head/grabpack_1/pack_full_timer

#Hold Items:

@onready var itemnodeL = $neck/head/grabpack_1/scale/pack_nodes/LHand/item
@onready var itemnodeR = $neck/head/grabpack_1/scale/pack_nodes/RHand/item
@onready var itemL_cast = $neck/head/grabpack_1/scale/pack_nodes/LHand/item/itemL_cast
@onready var itemR_cast = $neck/head/grabpack_1/scale/pack_nodes/RHand/item/itemR_cast
@onready var batteryL = $neck/head/grabpack_1/scale/pack_nodes/LHand/item/battery
@onready var batteryR = $neck/head/grabpack_1/scale/pack_nodes/RHand/item/battery

#AUDIO

@onready var switch_hand_sfx = $neck/head/grabpack_1/sfx/switch_hand
@onready var pull_l = $neck/head/grabpack_1/scale/pack_nodes/LHand/pullL
@onready var pull_r = $neck/head/grabpack_1/scale/pack_nodes/RHand/pullR
@onready var gas_equip = $ui/gas_mask/gas_equip
@onready var gas_remove = $ui/gas_mask/gas_remove
@onready var gas_breath = $ui/gas_mask/gas_breath

#Grabpack BTS:

@onready var pack_cast = $neck/head/eyes/Camera/pack_cast
var grab_speed = 35
var left_use = false
var grab_point = Vector3()
var l_hand_current = Vector3()
var l_hand_rot = Vector3()
var l_hand_locked = true
var l_retract_force = 0.0
var l_reached = false
var l_prev_point = Vector3()
var right_use = false
var r_grab_point = Vector3()
var r_hand_current = Vector3()
var r_hand_rot = Vector3()
var r_hand_locked = true
var r_retract_force = 0.0
var r_reached = false
var r_prev_point = Vector3()
var line_break_distance = 1
var quick_retract_l = true
var quick_retract_r = true
var l_hit_time = 0.0
var r_hit_time = 0.0
var switched_hand = 0
var can_shoot_right = false
var can_shoot_left = false
var PACK_LERP_SPEED = 5.0
var pull_speed = 0.25
var pull_point = Vector3()
var pulling = false
var drop_pull = false
var collect_hand = 0
var queue_collect = false
var left_click = false
var right_click = false
var collect_grabpack = 0
var reached_r = false
var reached_l = false
var crouch_notif = false
var itemR = 0
var itemL = 0
var has_grabpack = true
var jump_aligned = false
var hit_sfxL = false
var hit_sfxR = false
var hand_switch_anim = false
var mask_equipped = false
var gas_damage = false
var damage = 0.0
var switching_pack = false
var mobile_item_sel = false

#Grabpack_Line_L:
var l_current_lines = 0
var sub_1_pos = Vector3()
var sub_2_pos = Vector3()
var sub_3_pos = Vector3()
var line_l_position = Vector3()
var line_l_target = Vector3()
var fire_time = 0.0
#Grablines R:
var r_current_lines = 0
var r_sub_1_pos = Vector3()
var r_sub_2_pos = Vector3()
var r_sub_3_pos = Vector3()
var r_line_position = Vector3()
var r_line_target = Vector3()
var r_fire_time = 0.0
#HAND_VARS:
#BASE:
var unshootable_hands = [0, 4]

@onready var red = $neck/head/grabpack_1/scale/pack_nodes/RHand/red
@onready var green = $neck/head/grabpack_1/scale/pack_nodes/RHand/green
@onready var rocket = $neck/head/grabpack_1/scale/pack_nodes/RHand/rocket
@onready var flare = $neck/head/grabpack_1/scale/pack_nodes/RHand/flare
@onready var dash = $neck/head/grabpack_1/scale/pack_nodes/RHand/dash

@export_subgroup("Grabpack 2.0")
enum def_hand {
	None,
	Red_Hand,
	Green_Hand,
	Rocket_Hand,
	Flare_Hand,
	Dash_Hand,
	Previous_Hand,
}
##The hand that the Player starts with equipped if using the Grabpack 2.0
@export var defualt_hand: def_hand = def_hand.Previous_Hand
@export var red_hand = false
@export var green_hand = true
@export var rocket_hand = true
@export var flare_hand = false
@export var dash_hand = false
#EXTRA
@onready var green_lightning = preload("res://Player/Shaders/electricity_full.tres")
@onready var green_effect = $neck/head/grabpack_1/scale/pack_nodes/RHand/green/Skeleton3D/Object_73/OmniLight3D
@onready var green_model = $neck/head/grabpack_1/scale/pack_nodes/RHand/green/Skeleton3D/Object_73
@onready var green_sfx = $neck/head/grabpack_1/scale/pack_nodes/RHand/green/green_sfx
var green_started = false
@onready var flare_count = $neck/head/grabpack_1/scale/pack_nodes/RHand/flare/display/flare_count
@onready var flare_spawn = $neck/head/grabpack_1/scale/pack_nodes/RHand/flare/flare_spawn
@onready var flare_cast = $neck/head/grabpack_1/scale/pack_nodes/RHand/flare/flare_cast
@onready var fire_flare = $neck/head/grabpack_1/sfx/fire_flare
@onready var fire_flare_fail = $neck/head/grabpack_1/sfx/fire_flare_fail
@onready var display_anim_flare = $neck/head/grabpack_1/scale/pack_nodes/RHand/flare/display_anim

var current_flares = 5
var max_flares = 5
var can_shoot_flare = true

#PLAYER MANAGEMENT

var current_speed = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var direction = Vector3.ZERO
var is_walking = false
var is_sprinting = false
var is_crouching = false
var is_free_looking = false
var slide_vector = Vector2.ZERO
var wiggle_vector = Vector2.ZERO
var wiggle_index = 0.0
var wiggle_current_intensity = 0.0
var bunny_hop_speed = SPRINTING_SPEED
var last_velocity = Vector3.ZERO
var stand_after_roll = false
var walk_time = 0
var forever_time = 0.0
var can_move = true
var can_pack = true

var jump_time = 0.0

func _ready():
	extra_anim.play("idle")
	if grabpack_version == 0:
		_grab1_hand_reset()
	else:
		_grab2_hand_reset()
	if flashlight_flicker:
		flash.play("loop")
	_reset_needed_globals()
	_hide_lines_l()
	_hide_lines_r()
	_refresh_hand()
	_switch_grabpack(grabpack_version)
	if not start_with_grabpack:
		has_grabpack = false
	if not start_with_gas_mask:
		Player.has_mask = false
	else:
		Player.has_mask = true
	
	if not use_mobile_controls:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	else:
		MOUSE_SENS = MOUSE_SENS * 2.0
	Player.use_mobile = use_mobile_controls


func _input(event):
	if can_move:
		if event is InputEventMouseMotion:
			if not use_mobile_controls:
				if is_free_looking:
					neck.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
					neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
				else:
					rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
				head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
				head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
			elif Player.move_mouse:
				if is_free_looking:
					neck.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
					neck.rotation.y = clamp(neck.rotation.y, deg_to_rad(-120), deg_to_rad(120))
				else:
					rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
				head.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
				head.rotation.x = clamp(head.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	if can_pack:
		if grabpack_version == 1 and r_hand_locked:
			if Input.is_action_just_pressed("hand_switch_up"):
				_switch_hand_up()
			if Input.is_action_just_pressed("hand_switch_down"):
				_switch_hand_down()
			if Input.is_action_just_pressed("0") and red_hand:
				_switch_hand(1)
			if Input.is_action_just_pressed("1") and green_hand:
				_switch_hand(2)
			if Input.is_action_just_pressed("2") and rocket_hand:
				_switch_hand(3)
			if Input.is_action_just_pressed("3") and flare_hand:
				_switch_hand(4)
			if Input.is_action_just_pressed("4") and dash_hand:
				_switch_hand(5)
	if Input.is_action_just_pressed("mask") and Player.has_mask and can_move:
		if mask_equipped:
			_unequip_mask()
		else:
			_equip_mask()
	
	if mobile_item_sel:
		Input.action_press("use")
	
	if Input.is_action_just_pressed("fullscreen"):
		if Player.is_fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			Player.is_fullscreen = false
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			Player.is_fullscreen = true

func _physics_process(delta):
	var input_dir = Input.get_vector("left", "right", "forward", "back")
	
	if stand_after_roll:
		head.position.y = lerp(head.position.y, 0.0, delta * LERP_SPEED)
		standing_collision.disabled = true
		crouch_collision.disabled = false
		stand_after_roll = false
	if Input.is_action_pressed("crouch") or ray_cast_3d.is_colliding():
		if is_on_floor():
			current_speed = lerp(current_speed, CROUCHING_SPEED, delta * LERP_SPEED)
		head.position.y = lerp(head.position.y, CROUCHING_DEPTH, delta * 4.0)
		standing_collision.disabled = true
		crouch_collision.disabled = false
		wiggle_current_intensity = WIGGLE_ON_CROUCHING_INTENSITY
		wiggle_index += WIGGLE_ON_CROUCHING_SPEED * delta
		is_walking = false
		is_sprinting = false
		is_crouching = true
	else:
		head.position.y = lerp(head.position.y, 0.0, delta * 4.0)
		standing_collision.disabled = false
		crouch_collision.disabled = true
		slide_timer.stop()
		if gas_damage:
			current_speed = lerp(current_speed, CROUCHING_SPEED, delta * LERP_SPEED)
			wiggle_current_intensity = WIGGLE_ON_CROUCHING_INTENSITY
			wiggle_index += WIGGLE_ON_CROUCHING_SPEED * delta
			is_walking = false
			is_sprinting = false
			is_crouching = false
		else:
			if Input.is_action_pressed("sprint"):
				if !Input.is_action_pressed("jump"):
					bunny_hop_speed = SPRINTING_SPEED
				current_speed = lerp(current_speed, bunny_hop_speed, delta * LERP_SPEED)
				wiggle_current_intensity = WIGGLE_ON_SPRINTING_INTENSITY
				wiggle_index -= WIGGLE_ON_SPRINTING_SPEED * delta
				is_walking = false
				is_sprinting = true
				is_crouching = false
			else:
				current_speed = lerp(current_speed, WALKING_SPEED, delta * LERP_SPEED)
				wiggle_current_intensity = WIGGLE_ON_WALKING_INTENSITY
				wiggle_index -= WIGGLE_ON_WALKING_SPEED * delta
				is_walking = true
				is_sprinting = false
				is_crouching = false
	
	is_free_looking = false
	rotation.y += neck.rotation.y
	neck.rotation.y = 0
	eyes.rotation.z = lerp(
		eyes.rotation.z,
		0.0,
		delta*LERP_SPEED
	)
	
	if can_move:
		if not is_on_floor():
			jump_aligned = false
			jump_time += 0.01
			if jump_time > 0.1:
				jump_time = 0.1
			grabpack_1.position.y = lerp(grabpack_1.position.y, jump_time, 0.01)
			grabpack_1.rotation.x = lerp(grabpack_1.rotation.x, 0.0, delta * LERP_SPEED)
			velocity.y -= gravity * delta
		elif slide_timer.is_stopped() and input_dir != Vector2.ZERO:
			grabpack_1.position = lerp(
				grabpack_1.position,
				pack_defualt.position, 
				delta * PACK_LERP_SPEED
			)
			if last_velocity.y <= -1:
				jump_time = -0.5
				animation_player.play("landing")
				_rand_sfx("neck/head/grabpack_1/sfx/land", 1, 3)
			_land_anim(delta, true)
			wiggle_vector.y = sin(wiggle_index)
			wiggle_vector.x = sin(wiggle_index / 2) + 0.5
			eyes.position.y = lerp(
				eyes.position.y,
				wiggle_vector.y * (wiggle_current_intensity / 2.0), 
				delta * LERP_SPEED
			)
			eyes.position.x = lerp(
				eyes.position.x,
				wiggle_vector.x * wiggle_current_intensity, 
				delta * LERP_SPEED
			)
			if jump_time == 0:
				_grabpack_walk(delta)
		else:
			grabpack_1.position = lerp(
				grabpack_1.position,
				pack_defualt.position, 
				delta * PACK_LERP_SPEED
			)
			grabpack_1.rotation.z = lerp(
				grabpack_1.rotation.z,
				pack_defualt.rotation.z, 
				delta * PACK_LERP_SPEED
			)
			
			#grabpack land anim:
			
			_land_anim(delta, true)
			
			eyes.position.y = lerp(eyes.position.y, 0.0, delta * LERP_SPEED)
			eyes.position.x = lerp(eyes.position.x, 0.0, delta * LERP_SPEED)
			if last_velocity.y <= -1:
				jump_time = -0.5
				animation_player.play("landing")
				_rand_sfx("neck/head/grabpack_1/sfx/land", 1, 3)
	
	if can_move:
		if Input.is_action_pressed("jump") and is_on_floor():
			_jump(JUMP_VELOCITY)
	
	if slide_timer.is_stopped():
		if is_on_floor():
			direction = lerp(
				direction,
				(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
				delta * LERP_SPEED
			)
		elif input_dir != Vector2.ZERO:
			direction = lerp(
				direction,
				(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized(),
				delta * AIR_LERP_SPEED
			)
	else:
		direction = (transform.basis * Vector3(slide_vector.x, 0.0,slide_vector.y)).normalized()
		current_speed = (slide_timer.time_left / slide_timer.wait_time + 0.5) * SLIDING_SPEED
	
	current_speed = clamp(current_speed, 3.0, 12.0)
	
	if direction:
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	last_velocity = velocity
	
	if can_move:
		if is_crouching and not crouch_notif and not switching_pack:
			_rand_sfx("neck/head/grabpack_1/sfx/crouch", 3, 3)
			_rand_sfx("neck/head/grabpack_1/sfx/crouch", 1, 1)
			extra_anim.play("crouch")
			crouch_exit.stop()
			crouch_enter.start()
			crouch_notif = true
		if crouch_notif and not is_crouching and not switching_pack:
			_rand_sfx("neck/head/grabpack_1/sfx/crouch", 2, 2)
			_rand_sfx("neck/head/grabpack_1/sfx/crouch", 1, 1)
			extra_anim.play("crouch_exit")
			crouch_enter.stop()
			crouch_exit.start()
			crouch_notif = false
	
	if can_move and not pulling:
		move_and_slide()
	else:
		velocity = Vector3.ZERO
	
	if can_move:
		if input_dir != Vector2.ZERO and is_on_floor():
			walk_time += 1
			if is_crouching or gas_damage:
				if walk_time % 40 == 0:
					_rand_sfx("neck/head/grabpack_1/sfx/walk", 1, 6)
			elif is_sprinting:
				if walk_time % 15 == 0:
					_rand_sfx("neck/head/grabpack_1/sfx/run", 1, 6)
			else:
				if walk_time % 20 == 0:
					_rand_sfx("neck/head/grabpack_1/sfx/walk", 1, 6)
		else:
			walk_time = 0
	if input_dir == Vector2.ZERO:
		wiggle_index = 0
		wiggle_vector = Vector2.ZERO

func _grabpack_walk(delta):
	if jump_time == 0.0:
		grabpack_1.rotation.x = lerp(
			grabpack_1.rotation.x,
			-0.1 - wiggle_vector.y * (wiggle_current_intensity * 2), 
			delta * LERP_SPEED
		)
	
	#DIRECTIONAL SWAY
	
	var x_axis = 0
	var y_axis = 0
	
	if Input.is_action_pressed("forward"):
		grabpack_1.position.z = lerp(
			grabpack_1.position.z,
			pack_forward.position.z, 
			delta * PACK_LERP_SPEED
		)
		y_axis += 1
	if Input.is_action_pressed("back"):
		grabpack_1.position.z = lerp(
			grabpack_1.position.z,
			pack_backwards.position.z, 
			delta * PACK_LERP_SPEED
		)
		y_axis += 1
	if y_axis > 1:
		grabpack_1.position.z = lerp(
			grabpack_1.position.z,
			pack_defualt.position.z, 
			delta * PACK_LERP_SPEED
		)
	if y_axis == 0:
		grabpack_1.position.z = lerp(
			grabpack_1.position.z,
			pack_defualt.position.z, 
			delta * PACK_LERP_SPEED
		)
	
	if Input.is_action_pressed("left"):
		x_axis += 1
		grabpack_1.position.x = lerp(
			grabpack_1.position.x,
			pack_left.position.x, 
			delta * PACK_LERP_SPEED
		)
		grabpack_1.rotation.z = lerp(
			grabpack_1.rotation.z,
			pack_left.rotation.z, 
			delta * PACK_LERP_SPEED
		)
	if Input.is_action_pressed("right"):
		x_axis += 1
		grabpack_1.position.x = lerp(
			grabpack_1.position.x,
			pack_right.position.x, 
			delta * PACK_LERP_SPEED
		)
		grabpack_1.rotation.z = lerp(
			grabpack_1.rotation.z,
			pack_right.rotation.z, 
			delta * PACK_LERP_SPEED
		)
	
	if x_axis > 1:
		grabpack_1.position.x = lerp(
			grabpack_1.position.x,
			pack_forward.position.x, 
			delta * PACK_LERP_SPEED
		)
		grabpack_1.rotation.z = lerp(
			grabpack_1.rotation.z,
			pack_defualt.rotation.z, 
			delta * PACK_LERP_SPEED
		)
	if x_axis == 0:
		grabpack_1.position.x = lerp(
			grabpack_1.position.x,
			pack_forward.position.x, 
			delta * PACK_LERP_SPEED
		)
		grabpack_1.rotation.z = lerp(
			grabpack_1.rotation.z,
			pack_defualt.rotation.z, 
			delta * PACK_LERP_SPEED
		)

func _pull_towards_point(point, p_speed, drop):
	pulling = true
	pull_speed = p_speed
	pull_point = point
	drop_pull = drop
	swing_timer.start()
	_rand_sfx("neck/head/grabpack_1/sfx/swing", 1, 4)

func _cancel_pull():
	pulling = false

func _jump(jump_vel):
	_rand_sfx("neck/head/grabpack_1/sfx/jump", 1, 3)
	jump_time = 0
	animation_player.play("jump")
	if !slide_timer.is_stopped():
		velocity.y = jump_vel * 1.5
		slide_timer.stop()
	else:
		velocity.y = jump_vel
	if is_sprinting:
		bunny_hop_speed += BUNNY_HOP_ACCELERATION
	else:
		bunny_hop_speed = SPRINTING_SPEED

func _process(delta):
	can_shoot_right = true
	can_shoot_left = true
	
	if gas_damage:
		if not mask_equipped:
			if damage == 0.0:
				damage_anim.play("damage")
			damage += 0.1
		else:
			if damage > 0.0:
				damage_anim.play("RESET")
			damage = 0.0
	else:
		if damage > 0.0:
			damage_anim.play("RESET")
		damage = 0.0
	
	if Player.current_hand == 4:
		cross_normal.visible = false
		cross_flare.visible = true
	else:
		cross_normal.visible = true
		cross_flare.visible = false
	
	#FlASHLIGHT:
	
	if has_flashlight:
		flashlight.visible = true
		if grabpack_version == 0:
			flashlight.global_position = camera.global_position
		else:
			flashlight.global_position = flash_right_pos.global_position
	else:
		flashlight.visible = false
	
	if pulling:
		if global_position.distance_to(pull_point) < 2:
			if right_use and Player.is_dashing:
				_retract_right()
			Player.is_dashing = false
			if drop_pull:
				pulling = false
		else:
			global_position = global_position.move_toward(pull_point, pull_speed * delta)
	
	#GRABPACK_CODE:
	if not has_grabpack:
		grabpack.visible = false
		new_grabpack.visible = false
		pack_nodes.visible = false
		can_pack = false
	else:
		pack_nodes.visible = true
	
	if queue_collect:
		if r_hand_locked:
			_rand_sfx("neck/head/grabpack_1/sfx/switch", 1, 1)
			pack_player_r.play("collect_hand")
			hand_switch_timer.start()
			queue_collect = false
	
	if unshootable_hands.has(Player.current_hand):
		can_shoot_right = false
	if not can_pack:
		can_shoot_left = false
		can_shoot_right = false
	if itemL > 0:
		can_shoot_left = false
	if itemR > 0:
		can_shoot_right = false
	
	Player.left_click = left_click
	Player.right_click = right_click
	
	if Player.current_hand == 4:
		flare_count.text = str(current_flares)
		if Input.is_action_just_pressed("right_hand") and can_shoot_flare:
			if not current_flares < 1:
				if current_flares == max_flares:
					display_anim_flare.play("charge")
				current_flares -= 1
				pack_player_r.play("fire_flare")
				Player.flare_spawn_position = flare_cast.get_collision_point()
				var new_ball = ball_scene.instantiate()
				get_owner().add_child(new_ball)
				new_ball.global_position = flare_spawn.global_position
				fire_flare.play()
				can_shoot_flare = false
			else:
				fire_flare_fail.play()
	
	if Input.is_action_just_released("left_hand"):
		if left_use and not left_click:
			_retract_left()
		left_click = false
	if Input.is_action_just_pressed("left_hand"):
		if not left_use:
			if can_shoot_left:
				_rand_sfx("neck/head/grabpack_1/sfx/fireL_", 1, 3)
				l_current_lines = 0
				pull_l.play()
				l_anim.play("RESET")
				pack_playerl.play("fire_b")
				l_hand_locked = false
				if pack_cast.is_colliding():
					grab_point = pack_cast.get_collision_point()
				l_hand_rot = l_hand.global_rotation
				l_hand_current = l_hand.global_position
				left_use = true
				left_click = true
			if itemL > 0:
				_hold_item_l(0)
	if left_use:
		if l_hand_current == grab_point:
			if not reached_l:
				_rand_sfx("neck/head/grabpack_1/sfx/collide", 1, 3)
				reached_l = true
			pull_l.stop()
		if quick_retract_l:
			if l_hand.global_position.distance_to(grab_point) < 0.5:
				l_hit_time += 1 * delta
				if l_hit_time > 0.5:
					_retract_left()
		line_l.visible = true
		l_retract_force = 0
		l_hand_current = l_hand_current.move_toward(grab_point, grab_speed * delta)
		
		l_hand.global_position = l_hand_current
		l_hand.global_rotation = l_hand_rot
		l_hand.scale = Vector3(1, 1, 1)
	elif not l_hand_locked:
		_hide_lines_l()
		reached_l = false
		l_retract_force += 10 * delta
		line_l.look_at(l_hand.global_position)
		line_l.global_position = line_l_pos.global_position
		l_hand_current = l_hand_current.move_toward(l_hand_pos.global_position, grab_speed * delta)
		l_hand.global_position = l_hand_current
		if l_hand.global_position.distance_to(l_hand_pos.global_position) < 0.05:
			if not Player.source_hand:
				_unpower_line()
			_rand_sfx("neck/head/grabpack_1/sfx/retractL_", 1, 3)
			l_anim.play("pull_back_hit")
			pack_playerl.play("hit_3")
			l_hand_locked = true
	else:
		l_hit_time = 0.0
		quick_retract_l = true
		line_l.visible = false
		l_hand.rotation = l_hand_pos.rotation
		l_hand.position = l_hand_pos.position
		left_use = false
	#RIGHT HAND:
	
	if Input.is_action_just_released("right_hand"):
		if right_use and not right_click:
			_retract_right()
		right_click = false
	if Input.is_action_just_pressed("right_hand"):
		if not right_use:
			if can_shoot_right:
				_rand_sfx("neck/head/grabpack_1/sfx/fireR_", 1, 3)
				pull_r.play()
				r_anim.play("RESET")
				pack_player_r.play("fire_b")
				r_current_lines = 0
				r_hand_locked = false
				if pack_cast.is_colliding():
					r_grab_point = pack_cast.get_collision_point()
				r_hand_rot = r_hand.global_rotation
				r_hand_current = r_hand.global_position
				right_use = true
				right_click = true
			if itemR > 0:
				_hold_item_r(0)
	if right_use:
		if can_shoot_right:
			if r_hand_current == r_grab_point:
				if not reached_r:
					_rand_sfx("neck/head/grabpack_1/sfx/collide", 1, 3)
					reached_r = true
				pull_r.stop()
			if quick_retract_r:
				if r_hand.global_position.distance_to(r_grab_point) < 0.5:
					r_hit_time += 1 * delta
					if r_hit_time > 0.5:
						_retract_right()
			line_r.visible = true
			r_retract_force = 0
			r_hand_current = r_hand_current.move_toward(r_grab_point, grab_speed * delta)
			
			r_hand.global_position = r_hand_current
			r_hand.global_rotation = r_hand_rot
			r_hand.scale = Vector3(1, 1, 1)
	elif not r_hand_locked:
		_hide_lines_r()
		reached_r = false
		r_retract_force += 10 * delta
		line_r.look_at(r_hand.global_position)
		line_r.global_position = r_line_pos.global_position
		r_hand_current = r_hand_current.move_toward(r_hand_pos.global_position, grab_speed * delta)
		r_hand.global_position = r_hand_current
		if r_hand.global_position.distance_to(r_hand_pos.global_position) < 0.05:
			if Player.source_hand:
				_unpower_line()
			_rand_sfx("neck/head/grabpack_1/sfx/retractR_", 1, 3)
			r_anim.play("pull_back_hit")
			pack_player_r.play("hit_3")
			r_hand_locked = true
	else:
		r_hit_time = 0.0
		quick_retract_r = true
		line_r.visible = false
		r_hand.rotation = r_hand_pos.rotation
		r_hand.position = r_hand_pos.position
		right_use = false
	if left_use or not l_hand_locked:
		_fix_line_l()
	if right_use or not r_hand_locked:
		if not Player.rotating_pillar:
			_fix_line_r()
		else:
			_fix_line_r_pillar()
	var green_mat = green_model.mesh
	#GREEN EFFECT:
	if Player.green_powered:
		if not green_started:
			green_effect.visible = true
			green_sfx.play()
			green_mat.surface_get_material(0).next_pass = green_lightning
			green_mat.surface_get_material(0).emission_enabled = true
			green_started = true
	else:
		if green_started:
			green_effect.visible = false
			green_sfx.stop()
			green_mat.surface_get_material(0).next_pass = null
			green_mat.surface_get_material(0).emission_enabled = false
			green_started = false
	_remove_lines()
	Player.l_launched = left_use
	Player.r_launched = right_use
	Player.r_pos = r_hand.global_position
	Player.l_pos = l_hand.global_position
	Player.itemL_pos = itemnodeL.global_position
	Player.itemR_pos = itemnodeR.global_position
	Player.itemL_cast_point = itemL_cast.get_collision_point()
	Player.itemR_cast_point = itemR_cast.get_collision_point()
	Player.item_linear_vel = -camera.get_global_transform().basis.z * 10.0
	Player.item_position = global_position + Vector3(0,1.7,0);
	Player.item_position -= camera.get_global_transform().basis.z
	Player.current_pack = grabpack_version

func _retract_right():
	r_anim.play("pull_back")
	pull_r.play()
	r_hand.rotation = r_hand_pos.rotation
	r_hand.position = r_hand_pos.position
	right_use = false

func _retract_left():
	l_anim.play("pull_back")
	pull_l.play()
	l_hand.rotation = l_hand_pos.rotation
	l_hand.position = l_hand_pos.position
	left_use = false

func _retract_hands():
	if left_use:
		_retract_left()
	if right_use:
		_retract_right()

func _rand_sfx(path, low, high):
	var sfx = floor(randi_range(low, high))
	var sfx_string = str(path, sfx)
	var sfx_path = NodePath(sfx_string)
	var sfx_node = get_node(sfx_path)
	sfx_node.play()

func _hide_lines_l():
	fire_time = 0
	l_current_lines = 0
	line_l_sub_1.visible = false
	line_l_sub_2.visible = false
	line_l_sub_3.visible = false

func _hide_lines_r():
	r_fire_time = 0
	r_current_lines = 0
	line_r_sub_1.visible = false
	line_r_sub_2.visible = false
	line_r_sub_3.visible = false

func _fix_line_l():
	fire_time += 0.1
	line_l.global_position = line_l_pos.global_position
	line_l_position = line_l.global_position
	line_l.scale.z = line_l_position.distance_to(line_l_target) / 2
	
	# Line Direction Management:
	if l_current_lines > 0:
		line_l_sub_1.scale.z = sub_1_pos.distance_to(hand_l_marker.global_position) / 2
		line_l_sub_1.global_position = sub_1_pos
		line_l_sub_2.global_position = sub_2_pos
		line_l_sub_3.global_position = sub_3_pos
		line_l_sub_1.look_at(hand_l_marker.global_position)
		if l_current_lines < 2:
			line_l.look_at(line_l_sub_1.global_position)
			line_l_target = line_l_sub_1.global_position
		elif l_current_lines < 3:
			line_l_sub_2.look_at(line_l_sub_1.global_position)
			line_l.look_at(line_l_sub_2.global_position)
			line_l_target = line_l_sub_2.global_position
		elif l_current_lines < 4:
			line_l_sub_2.look_at(line_l_sub_1.global_position)
			line_l_sub_3.look_at(line_l_sub_2.global_position)
			line_l.look_at(line_l_sub_3.global_position)
			line_l_target = line_l_sub_3.global_position
	else:
		line_l.look_at(hand_l_marker.global_position)
		line_l_target = hand_l_marker.global_position
	
	# Check for collisions and update sub positions
	if line_cast.is_colliding() and fire_time > 2.0:
		var collision_point = line_cast.get_collision_point()
		if l_current_lines == 0:
			sub_1_pos = collision_point
			if sub_1_pos.distance_to(grab_point) >= line_break_distance:
				l_current_lines += 1
				line_l_sub_1.visible = true
		elif l_current_lines == 1:
			sub_2_pos = collision_point
			if sub_2_pos.distance_to(sub_1_pos) >= line_break_distance:
				l_current_lines += 1
				line_l_sub_2.scale.z = sub_2_pos.distance_to(line_l_sub_1.global_position) / 2
				line_l_sub_2.visible = true
		elif l_current_lines == 2:
			sub_3_pos = collision_point
			if sub_3_pos.distance_to(sub_2_pos) >= line_break_distance:
				l_current_lines += 1
				line_l_sub_3.scale.z = sub_3_pos.distance_to(line_l_sub_2.global_position) / 2
				line_l_sub_3.visible = true

func _fix_line_r_pillar():
	line_r.visible = false

func _fix_line_r():
	r_fire_time += 0.1
	line_r.global_position = r_line_pos.global_position
	r_line_position = line_r.global_position
	line_r.scale.z = r_line_position.distance_to(r_line_target) / 2
	
	# Line Direction Management:
	if r_current_lines > 0:
		line_r_sub_1.scale.z = r_sub_1_pos.distance_to(r_hand_marker.global_position) / 2
		line_r_sub_1.global_position = r_sub_1_pos
		line_r_sub_2.global_position = r_sub_2_pos
		line_r_sub_3.global_position = r_sub_3_pos
		line_r_sub_1.look_at(r_hand_marker.global_position)
		if r_current_lines < 2:
			line_r.look_at(line_r_sub_1.global_position)
			r_line_target = line_r_sub_1.global_position
		elif r_current_lines < 3:
			line_r_sub_2.look_at(line_r_sub_1.global_position)
			line_r.look_at(line_r_sub_2.global_position)
			r_line_target = line_r_sub_2.global_position
		elif r_current_lines < 4:
			line_r_sub_2.look_at(line_r_sub_1.global_position)
			line_r_sub_3.look_at(line_r_sub_2.global_position)
			line_r.look_at(line_r_sub_3.global_position)
			r_line_target = line_r_sub_3.global_position
	else:
		line_r.look_at(r_hand_marker.global_position)
		r_line_target = r_hand_marker.global_position
	
	# Check for collisions and update sub positions
	if r_line_cast.is_colliding() and r_fire_time > 2.0:
		var collision_point = r_line_cast.get_collision_point()
		if r_current_lines == 0:
			r_sub_1_pos = collision_point
			if r_sub_1_pos.distance_to(r_grab_point) >= line_break_distance:
				r_current_lines += 1
				line_r_sub_1.visible = true
		elif r_current_lines == 1:
			r_sub_2_pos = collision_point
			if r_sub_2_pos.distance_to(r_sub_1_pos) >= line_break_distance:
				r_current_lines += 1
				line_r_sub_2.scale.z = r_sub_2_pos.distance_to(line_r_sub_1.global_position) / 2
				line_r_sub_2.visible = true
		elif r_current_lines == 2:
			r_sub_3_pos = collision_point
			if r_sub_3_pos.distance_to(r_sub_2_pos) >= line_break_distance:
				r_current_lines += 1
				line_r_sub_3.scale.z = r_sub_3_pos.distance_to(line_r_sub_2.global_position) / 2
				line_r_sub_3.visible = true

func _remove_lines():
	if l_hand_locked and not left_use:
		line_l.position.y = 10000
	if r_hand_locked and not right_use:
		line_r.position.y = 10000
	if l_current_lines < 1:
		line_l_sub_1.position.y = 10000
	if l_current_lines < 2:
		line_l_sub_2.position.y = 10000
	if l_current_lines < 3:
		line_l_sub_3.position.y = 10000
	if r_current_lines < 1:
		line_r_sub_1.position.y = 10000
	if r_current_lines < 2:
		line_r_sub_2.position.y = 10000
	if r_current_lines < 3:
		line_r_sub_3.position.y = 10000

func _power_line():
	var line_material = line_mesh.mesh.material
	line_material.emission_enabled = true
	Player.line_power = true
	if not Player.source_hand:
		quick_retract_l = false
	if Player.source_hand:
		quick_retract_r = false

func _unpower_line():
	var line_material = line_mesh.mesh.material
	line_material.emission_enabled = false
	Player.line_power = false

func _show_crosshair():
	crosshair.visible = true

func _hide_crosshair():
	crosshair.visible = false

func _disable_movement(disable_pack):
	can_move = false
	can_pack = !disable_pack

func _enable_movement(enable_pack):
	can_move = true
	can_pack = enable_pack

func _take_camera_control():
	camera.current = true

func _get_hands(grabpack):
	if grabpack == 1:
		return(starting_hand)
	else:
		return(defualt_hand)

func _switch_grabpack(pack):
	can_pack = true
	has_grabpack = true
	if pack == 0:
		_grab1_hand_reset()
		grabpack.visible = true
		new_grabpack.visible = false
		grabpack_version = 0
	elif pack == 1:
		if Player.current_hand == 1:
			red_hand = true
		if Player.current_hand == 2:
			green_hand = true
		if Player.current_hand == 3:
			rocket_hand = true
		if Player.current_hand == 4:
			flare_hand = true
		if Player.current_hand == 5:
			dash_hand = true
		_grab2_hand_reset()
		grabpack.visible = false
		new_grabpack.visible = true
		grabpack_version = 1
	l_anim.play("RESET")
	r_anim.play("RESET")
	_refresh_hand()

func _grab1_hand_reset():
	Player.current_hand = starting_hand
	_refresh_hand()

func _grab2_hand_reset():
	if not defualt_hand == def_hand.size() - 1:
		Player.current_hand = defualt_hand
	_refresh_hand()

func _collect_pack(pack):
	switching_pack = true
	collect_grabpack = pack
	extra_anim.play("switch_pack_v2")
	pack_switch_timer.start()

func _collect_hand(hand):
	if grabpack_version == 0:
		collect_hand = hand
		queue_collect = true
	else:
		if hand == 1:
			red_hand = true
		if hand == 2:
			green_hand = true
		if hand == 3:
			rocket_hand = true
		if hand == 4:
			flare_hand = true
		if hand == 5:
			dash_hand = true

func _switch_hand_up():
	var switch_hand = Player.current_hand
	switch_hand += 1
	_switch_hand(switch_hand)

func _switch_hand_down():
	var switch_hand = Player.current_hand
	switch_hand -= 1
	_switch_hand(switch_hand)

func _switch_hand(hand):
	if not hand_switch_anim:
		switch_hand_sfx.play()
		pack_player_r.play("RESET")
		new_pack_anim.play("Armature|A_FirstPersonPlayer_HandSwitch")
		switched_hand = hand
		switch_timer.start()
		hand_switch_anim = true

func _on_switch_timer_timeout():
	Player.current_hand = switched_hand
	_refresh_hand()

func _refresh_hand():
	red.visible = false
	green.visible = false
	rocket.visible = false
	flare.visible = false
	dash.visible = false
	if Player.current_hand == 1:
		red.visible = true
	if Player.current_hand == 2:
		green.visible = true
	if Player.current_hand == 3:
		rocket.visible = true
	if Player.current_hand == 4:
		flare.visible = true
	if Player.current_hand == 5:
		dash.visible = true

func _update_r_position(pos, rot):
	r_grab_point = pos
	r_hand_rot = rot

func _update_l_position(pos, rot):
	grab_point = pos
	l_hand_rot = rot

func _set_retract_mode_r(mode):
	quick_retract_r = mode

func _set_retract_mode_l(mode):
	quick_retract_l = mode

func _update_l_anim(anim):
	l_anim.play(anim)

func _update_r_anim(anim):
	r_anim.play(anim)

func _hold_item_r(item_id):
	batteryR.visible = false
	itemR = item_id
	if item_id == 1:
		batteryR.visible = true

func _hold_item_l(item_id):
	batteryL.visible = false
	itemL = item_id
	if item_id == 1:
		batteryL.visible = true

func _land_anim(delta, reset):
	if jump_time < 0:
		jump_time += 0.05
		grabpack_1.rotation.x = lerp(grabpack_1.rotation.x, jump_time, delta * LERP_SPEED)
	elif reset:
		grabpack_1.rotation.x = lerp(grabpack_1.rotation.x, 0.0, delta * LERP_SPEED)
	if jump_time < -0.5:
		jump_time = -0.5
	if jump_time > 0:
		jump_time = 0

func _collect_mask():
	Player.has_mask = true

func _lose_mask():
	if mask_equipped:
		_unequip_mask()
	Player.has_mask = false

func _equip_mask():
	mask_equipped = true
	gas_equip.play()
	gas_breath.play()
	ui_anim.play("gas_equip")

func _unequip_mask():
	mask_equipped = false
	gas_remove.play()
	gas_breath.stop()
	ui_anim.play("gas_remove")

func _die():
	var cur_scene = get_tree().current_scene
	Player.previous_level = cur_scene.scene_file_path
	get_tree().change_scene_to_file("res://Player/UI/death.tscn")

func _on_sliding_timer_timeout():
	is_free_looking = false

func _on_animation_player_animation_finished(anim_name):
	stand_after_roll = anim_name == 'roll' and !is_crouching

func _on_l_anim_animation_finished(anim_name):
	if anim_name == "pull_back_hit":
		pull_l.stop()
		l_anim.play("RESET")

func _on_r_anim_animation_finished(anim_name):
	if anim_name == "pull_back_hit":
		pull_r.stop()
		r_anim.play("RESET")

func _reset_needed_globals():
	Player.line_power = false
	Player.current_powered_poles = 0
	Player.green_powered = false

func _on_pack_switch_timer_timeout():
	if collect_grabpack == 0:
		_switch_grabpack(0)
	elif collect_grabpack == 1:
		_switch_grabpack(1)

func _on_extra_anim_animation_finished(anim_name):
	if anim_name == "switch_pack" or anim_name == "switch_pack_v2":
		extra_anim.play("idle")
		switching_pack = false

func _on_reload_timer_timeout(anim):
	if anim == "charge":
		current_flares += 1
		if not current_flares == max_flares:
			display_anim_flare.play("charge")

func _on_swing_timer_timeout():
	if pulling:
		_rand_sfx("neck/head/grabpack_1/sfx/swing", 1, 4)

func _on_hand_switch_timer_timeout():
	Player.current_hand = collect_hand
	_rand_sfx("neck/head/grabpack_1/sfx/switch", 2, 2)
	_refresh_hand()

func _on_crouch_enter_timeout():
	extra_anim.play("idle")

func _on_crouch_exit_timeout():
	extra_anim.play("idle")

func _on_new_pack_anim_animation_finished(anim_name):
	if anim_name == "Armature|A_FirstPersonPlayer_HandSwitch":
		hand_switch_anim = false

func _on_pack_player_r_animation_finished(anim_name):
	if anim_name == "fire_flare":
		can_shoot_flare = true

func _on_gas_det_area_entered(area):
	gas_damage = true

func _on_gas_det_area_exited(area):
	gas_damage = false

func _on_damage_anim_animation_finished(anim_name):
	if anim_name == "damage":
		_die()

func _on_item_col_area_entered(area):
	if Player.use_mobile:
		mobile_item_sel = true

func _on_item_col_area_exited(area):
	if Player.use_mobile:
		mobile_item_sel = false
		Input.action_release("use")
