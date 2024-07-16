extends StaticBody3D

@onready var light = $light
@onready var charge = $charge
@onready var discharge = $discharge

@export_category("Settings")
##If enabled, the puzzle pillar can be powered by the grabpack. This can be changed during gameplay.
@export var can_power = true

var ready_to_power = false
var powered = false
var current_area = 0

signal pole_disabled
signal pole_powered

func _ready():
	light.visible = false

func _process(delta):
	if ready_to_power and Player.line_power:
		if not powered:
			_charge()
	if not Player.line_power and powered:
		_dis_charge()

func _charge():
	ready_to_power = true
	if Player.line_power:
		emit_signal("pole_powered")
		light.visible = true
		powered = true
		charge.play()
		Player.current_powered_poles += 1

func _dis_charge():
	ready_to_power = false
	emit_signal("pole_disabled")
	light.visible = false
	powered = false
	discharge.play()
	Player.current_powered_poles -= 1

func _on_line_detection_area_entered(area):
	current_area += 1
	if current_area == 1:
		_charge()

func _on_line_detection_area_exited(area):
	current_area -= 1
	if current_area < 1 and powered == true:
		_dis_charge()
