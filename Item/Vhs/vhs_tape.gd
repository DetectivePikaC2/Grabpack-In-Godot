@tool
extends Node3D

@export_category("Settings")
##The vhs name that appears on the top of this tape
@export var vhs_name = "VHS"
##Size of the vhs name that appears on the top
@export var text_size = 30

@onready var collect = $collect
@onready var label_3d = $SK_VHSTape_ao/Object_4/Skeleton3D/Label3D

var owned = false
var sel = false

signal collected

func _process(delta):
	label_3d.text = vhs_name
	if text_size < 1:
		text_size = 1
	label_3d.font_size = text_size

func _collect():
	if not owned:
		position.y -= 400
		visible = false
		emit_signal("collected")
		collect.play()
		owned = true

func _on_det_area_entered(area):
	if get_true_collision(area):
		_collect()
		get_tree().call_group("player", "_retract_hands")

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
	if Input.is_action_just_pressed("use") and sel:
		_collect()

func _on_item_det_area_entered(area):
	sel = true

func _on_item_det_area_exited(area):
	sel = false
