extends Node3D

@export_category("Settings")
##If enabled, the collect jingle will play.
@export var play_collect_jingle = false

@onready var jingle = $jingle
@onready var collect = $collect

var sel = false

signal collected

func _collect():
	position.y += 400
	visible = false
	emit_signal("collected")
	collect.play()
	jingle.play()
	if not play_collect_jingle:
		jingle.volume_db = -80

func _on_det_area_entered(area):
	if get_true_collision(area):
		get_tree().call_group("player", "_collect_mask")
		get_tree().call_group("player", "_retract_hands")
		_collect()

func _on_jingle_finished():
	queue_free()

func get_true_collision(area):
	var layer = area.collision_layer
	if layer == 8:
		if Player.l_launched:
			return(true)
		else:
			return(false)
	if layer == 16:
		if Player.r_launched:
			return(true)
		else:
			return(false)

func _input(event):
	if Input.is_action_just_pressed("use"):
		if sel:
			get_tree().call_group("player", "_collect_mask")
			get_tree().call_group("player", "_retract_hands")
			_collect()

func _on_item_det_area_entered(area):
	sel = true

func _on_item_det_area_exited(area):
	sel = false
