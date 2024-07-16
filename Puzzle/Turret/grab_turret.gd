extends StaticBody3D

@onready var camera = $base/hinge/Camera3D
@onready var hinge = $base/hinge
@onready var base = $base
@onready var hand_cast = $base/hinge/Camera3D/hand_cast
@onready var hand = $base/hinge/hand
@onready var set_position = $base/hinge/set_position
@onready var line = $base/hinge/line
@onready var line_position = $base/hinge/line_position
@onready var ui = $CanvasLayer/ui
@onready var use = $sfx/use
@onready var leave1 = $sfx/leave1
@onready var leave2 = $sfx/leave2
@onready var shoot = $sfx/shoot
@onready var retract = $sfx/retract

var sel = false
var using = false
var fired = false

var hand_current = Vector3()
var hand_locked = true
var grab_point = Vector3()

var MOUSE_SENS = 0.1

# Called every frame. 'delta' is the elapsed time since the previous frame.

func _input(event):
	if Input.is_action_just_pressed("use") and not fired:
		if not using:
			if sel:
				use.play()
				get_tree().call_group("player", "_disable_movement", true)
				get_tree().call_group("player", "_hide_crosshair")
				ui.visible = true
				camera.current = true
				using = true
		else:
			if randi_range(1, 2) == 1:
				leave1.play()
			else:
				leave2.play()
			get_tree().call_group("player", "_enable_movement", true)
			get_tree().call_group("player", "_show_crosshair")
			get_tree().call_group("player", "_take_camera_control")
			ui.visible = false
			using = false
	if Input.is_action_just_released("left_hand") and using:
		if randi_range(1, 2) == 1:
			leave1.play()
		else:
			leave2.play()
		get_tree().call_group("player", "_enable_movement", true)
		get_tree().call_group("player", "_show_crosshair")
		get_tree().call_group("player", "_take_camera_control")
		ui.visible = false
		using = false
	if using:
		if event is InputEventMouseMotion:
			base.rotate_y(deg_to_rad(-event.relative.x * MOUSE_SENS))
			hinge.rotate_x(deg_to_rad(-event.relative.y * MOUSE_SENS))
			hinge.rotation.x = clamp(hinge.rotation.x, deg_to_rad(-50), deg_to_rad(50))
			base.rotation.y = clamp(base.rotation.y, deg_to_rad(-50), deg_to_rad(50))

func _process(delta):
	if fired:
		hand_current = hand_current.move_toward(grab_point, 35 * delta)
		hand.global_position = hand_current
		line.position = line_position.position
		line.scale.z = line_position.global_position.distance_to(hand.global_position) / 2
		line.look_at(hand.global_position)
		line.visible = true
	else:
		hand_current = hand_current.move_toward(set_position.global_position, 35 * delta)
		hand.global_position = hand_current
		line.visible = false
	
	if hand_current == set_position.global_position:
		hand_locked = true
	else:
		hand_locked = false

func _fire_hand():
	grab_point = hand_cast.get_collision_point()
	shoot.play()
	fired = true

func _release_hand():
	retract.play()
	fired = false

func _on_det_area_entered(area):
	sel = true

func _on_det_area_exited(area):
	sel = false

func _on_lever_pulled(direction):
	if not fired:
		_fire_hand()
	else:
		_release_hand()
