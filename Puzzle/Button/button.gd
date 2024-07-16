extends StaticBody3D

@onready var markL = $button/SM_SimpleButton_B/markL
@onready var markR = $button/SM_SimpleButton_B/markR
@onready var anim = $AnimationPlayer
@onready var press = $press

var selectedL = false
var selectedR = false
var sel = false

signal pressed

func _process(delta):
	if selectedL:
		get_tree().call_group("player", "_update_l_position", markL.global_position, markL.global_rotation)
		if not Player.l_launched:
			selectedL = false
	if selectedR:
		get_tree().call_group("player", "_update_r_position", markR.global_position, markR.global_rotation)
		if not Player.r_launched:
			selectedR = false

func _input(event):
	if Input.is_action_just_pressed("use"):
		if sel:
			anim.play("press")
			press.play()
			emit_signal("pressed")

func _on_item_det_area_entered(area):
	sel = true

func _on_item_det_area_exited(area):
	sel = false

func _on_det_l_area_entered(area):
	if Player.l_launched and not selectedL and not selectedR:
		get_tree().call_group("player", "_update_l_anim", "grab_coil")
		anim.play("press")
		press.play()
		emit_signal("pressed")
		selectedL = true

func _on_det_r_area_entered(area):
	if Player.r_launched and not selectedL and not selectedR:
		get_tree().call_group("player", "_update_r_anim", "grab_coil")
		anim.play("press")
		press.play()
		emit_signal("pressed")
		selectedR = true
