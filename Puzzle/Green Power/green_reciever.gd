extends StaticBody3D

@onready var light = $OmniLight3D
@onready var puzzle_complete = $puzzle_complete
@onready var recieved = $recieved
@onready var disable = $disable

@export_category("Settings")
##If enabled, it plays the puzzle complete sound when powered
@export var play_complete_sound = false

var powered = false

signal power_recieved

func _power():
	if not powered:
		emit_signal("power_recieved")
		if play_complete_sound:
			puzzle_complete.play()
		Player.green_powered = false
		recieved.play()
		light.visible = true
		powered = true
		get_tree().call_group("green_puzzle", "_regenerate_power")

func _unpower():
	powered = false
	light.visible = false
	disable.play()

func _on_r_area_entered(area):
	if Player.green_powered:
		_power()
