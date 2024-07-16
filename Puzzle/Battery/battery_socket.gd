extends StaticBody3D

@onready var idle_loop = $sfx/idle_loop
@onready var lockin = $sfx/lockin
@onready var power = $sfx/power
@onready var release = $sfx/release

@export_category("Settings")
##If enabled, the Player can remove batteries from this socket after placing them in.
@export var allow_removal = true

@onready var battery_pos = $battery_pos

var battery_id = randi_range(1, 100000)
var has_battery = false

signal battery_placed
signal battery_removed

func _on_battery_det_body_entered(body):
	if body.call("_align_socket", battery_pos.global_position, battery_pos.global_rotation, allow_removal, battery_id) and not has_battery:
		lockin.play()
		power.play()
		idle_loop.play()
		has_battery = true
		emit_signal("battery_placed")

func _on_battery_det_body_exited(body):
	if body.is_in_group("battery"):
		if body.call("_check_socket", battery_id):
			battery_id = randi_range(1, 100000)
			release.play()
			idle_loop.stop()
			has_battery = false
			emit_signal("battery_removed")
