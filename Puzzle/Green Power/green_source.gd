extends StaticBody3D

@onready var timer = $Timer
@onready var light = $OmniLight3D
@onready var disable = $disable
@onready var recieved = $recieved

@export_category("Settings")
##If enabled, this power source has power. This can be changed during gameplay.
@export var has_power = true
##The amount of time the green hand keeps the power from here before running out.
@export var power_keep_time = 8

var state = true

func _give_power():
	if state and not Player.green_powered:
		timer.start(power_keep_time)
		state = false
		light.visible = false
		disable.play()
		Player.green_powered = true

func _regenerate_power():
	if not state:
		state = true
		recieved.play()
		light.visible = true
		Player.green_powered = false

func _on_r_area_entered(area):
	if Player.current_hand == 2:
		_give_power()
func _on_timer_timeout():
	_regenerate_power()
