extends StaticBody3D

@onready var l = $l
@onready var r = $r
@onready var power_sfx = $power
@onready var markL = $markL
@onready var markR = $markR

@export_category("Settings")
##If enabled, can power the grabpack when grabbed. Can be changed during gameplay.
@export var can_power = true

var powering = false
var current_shapes = 0
var exited = true
var l_col = false
var r_col = false
var queue = false

signal pole_powered

func _charge():
	power_sfx.play()
	powering = true
	emit_signal("pole_powered")
	if l_col:
		Player.source_hand = false
	if r_col:
		Player.source_hand = true
	get_tree().call_group("player", "_power_line")

func _dis_charge():
	powering = false
	get_tree().call_group("player", "_unpower_line")

func _process(delta):
	if current_shapes < 0:
		current_shapes = 0
	if powering and l_col:
		if not Player.l_launched:
			exited = true
			_dis_charge()
	if powering and r_col:
		if not Player.r_launched:
			exited = true
			_dis_charge()

func _on_hand_col_area_exited(area):
	current_shapes -= 1
	if l_col:
		if not Player.l_launched:
			exited = true
			if current_shapes == 0:
				_dis_charge()
	if r_col:
		if not Player.r_launched:
			exited = true
			if current_shapes == 0:
				_dis_charge()

func _on_l_area_entered(area):
	if Player.l_launched:
		l_col = true
		current_shapes += 1
		if current_shapes == 1 and exited:
			get_tree().call_group("player", "_update_l_anim", "grab_coil")
			get_tree().call_group("player", "_update_l_position", markL.global_position, markL.global_rotation)
			_charge()
			exited = false

func _on_l_area_exited(area):
	l_col = false


func _on_r_area_entered(area):
	if Player.r_launched:
		r_col = true
		current_shapes += 1
		if current_shapes == 1 and exited:
			get_tree().call_group("player", "_update_r_anim", "grab_coil")
			get_tree().call_group("player", "_update_r_position", markR.global_position, markR.global_rotation)
			_charge()
			exited = false

func _on_r_area_exited(area):
	r_col = false
