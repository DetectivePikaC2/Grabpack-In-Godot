extends StaticBody3D

@export_category("Settings")
##If enabled, the scanner works. Can be changed while the game is running.
@export var powered = true

@onready var markL = $l_marker
@onready var anim = $AnimationPlayer
@onready var scan_time = $scan_time
@onready var light = $light
@onready var scan = $scan

var selected = false
var scanning = false
var finished = false

signal scan_complete

func _on_det_r_area_entered(area):
	if Player.r_launched and not selected:
		get_tree().call_group("player", "_update_r_position", markL.global_position, markL.global_rotation)
		get_tree().call_group("player", "_set_retract_mode_r", false)
		get_tree().call_group("player", "_update_r_anim", "grab_scanner")
		if Player.current_hand == 2 and powered and not finished:
			scan.play()
			anim.play("fill")
			scan_time.start()
			scanning = true
		selected = true

func _process(delta):
	if not powered:
		light.visible = false
	
	if scanning:
		light.visible = true
	
	if selected:
		if not Player.r_launched:
			if scanning:
				scan.stop()
				anim.play("RESET")
				scan_time.stop()
			scanning = false
			selected = false

func _on_scan_time_timeout():
	finished = true
	scanning = false
	emit_signal("scan_complete")
