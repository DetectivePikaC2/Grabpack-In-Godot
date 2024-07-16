extends Control

@onready var prev = $ColorRect
@onready var jump = $jump
@onready var left_hand = $left_hand
@onready var right_hand = $right_hand
@onready var switch_up = $switch_up
@onready var switch_down = $switch_down
@onready var crouch = $crouch
@onready var gas_equip = $gas_equip
@onready var virtual_joystick = $"Virtual Joystick"

var deleted = false

var move_mouse = false
var can_move = false
var screen_drag_time = 0.0
var prev_screen_drag_time = 0.0
var l_press = false
var r_press = false
var e_press = false

func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			if move_mouse:
				Player.move_mouse = true
			else:
				Player.move_mouse = false
		else:
			Player.move_mouse = false
	if Player.use_mobile:
		Input.action_press("sprint")
	if not Player.use_mobile:
		if Input.is_action_pressed("left_mouse"):
			Input.action_press("left_hand")
			l_press = true
		else:
			if l_press:
				Input.action_release("left_hand")
				l_press = false
		if Input.is_action_pressed("right_mouse"):
			Input.action_press("right_hand")
			r_press = true
		else:
			if r_press:
				Input.action_release("right_hand")
				r_press = false

func _process(delta):
	if not Player.use_mobile:
		if not deleted:
			virtual_joystick.queue_free()
			left_hand.queue_free()
			right_hand.queue_free()
			jump.queue_free()
			switch_up.queue_free()
			switch_down.queue_free()
			crouch.queue_free()
			gas_equip.queue_free()
			deleted = true
	else:
		if Player.current_pack < 1:
			switch_up.visible = false
			switch_down.visible = false
		else:
			switch_up.visible = true
			switch_down.visible = true
		
		if Player.has_mask:
			gas_equip.visible = true
		else:
			gas_equip.visible = false

#CONTROL_PRESSED

func _on_mouse_region_mouse_entered():
	move_mouse = true

func _on_mouse_region_mouse_exited():
	move_mouse = false
