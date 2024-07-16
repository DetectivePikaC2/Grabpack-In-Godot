extends StaticBody3D

@onready var button = $RootNode/SM_Playhouse_Button_Inner_mo
@onready var btn_top = $RootNode/btn_top
@onready var btn_bottom = $RootNode/btn_bottom
@onready var press = $press
@onready var release = $release

var status = false
var current_bodies = 0

var lerp_speed = 10

signal pressed
signal released

func _process(delta):
	if status:
		button.position = btn_bottom.position
	else:
		button.position = btn_top.position

func _on_det_body_entered(body):
	current_bodies += 1
	if current_bodies == 1:
		status = true
		press.play()
		emit_signal("pressed")

func _on_det_body_exited(body):
	current_bodies -= 1
	if current_bodies < 1:
		status = false
		release.play()
		emit_signal("released")
