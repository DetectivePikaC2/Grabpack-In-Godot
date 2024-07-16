extends StaticBody3D

@export_category("Settings")
##Set this to the VHS Tape for this Player
@export var vhs_tape = Node3D
##Set this to the VHS TV that this player is for
@export var tv = StaticBody3D

@onready var insert = $insert
@onready var anim = $animation
@onready var vhs_marker = $vhs_marker

var sel = false
var insterted = false

func _process(delta):
	if insterted:
		vhs_tape.global_position = vhs_marker.global_position
		vhs_tape.global_rotation = vhs_marker.global_rotation

func _input(event):
	if Input.is_action_just_pressed("use") and sel:
		if vhs_tape.owned and not insterted:
			vhs_tape.visible = true
			anim.play("insert")
			insert.play()
			insterted = true

func _on_item_det_area_entered(area):
	sel = true

func _on_item_det_area_exited(area):
	sel = false

func _on_insert_finished():
	tv._play()
