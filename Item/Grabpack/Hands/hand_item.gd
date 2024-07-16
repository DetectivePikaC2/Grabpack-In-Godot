@tool
extends Node3D

@onready var red = $hands/red
@onready var green = $hands/green
@onready var rocket = $hands/rocket
@onready var flare = $hands/flare
@onready var dash = $hands/dash

enum hand_types {
	Red,
	Green,
	Rocket,
	Flare,
	Dash
}

@export_category("Settings")
##Which hand this collectable hand is.
@export var hand: hand_types = hand_types.Green
##If enabled, a the collect jingle will play.
@export var play_collect_jingle = false

@onready var jingle = $jingle
@onready var collect = $collect

var prev_hand = null
var sel = false

signal collected

func _process(delta):
	if not prev_hand == hand:
		_set_type(hand)
	prev_hand = hand

func _set_type(type):
	red.visible = false
	green.visible = false
	rocket.visible = false
	flare.visible = false
	dash.visible = false
	if type == 0:
		red.visible = true
	if type == 1:
		green.visible = true
	if type == 2:
		rocket.visible = true
	if type == 3:
		flare.visible = true
	if type == 4:
		dash.visible = true

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
		get_tree().call_group("player", "_collect_hand", hand + 1)
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
			get_tree().call_group("player", "_collect_hand", hand + 1)
			get_tree().call_group("player", "_retract_hands")
			_collect()

func _on_item_det_area_entered(area):
	sel = true

func _on_item_det_area_exited(area):
	sel = false
