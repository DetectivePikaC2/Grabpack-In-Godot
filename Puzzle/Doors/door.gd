@tool
extends StaticBody3D

@onready var frame_cyan = $frame/cyan
@onready var frame_grey = $frame/grey
@onready var frame_red = $frame/red
@onready var frame_yellow = $frame/yellow
@onready var cyan = $frame/door/cyan
@onready var grey = $frame/door/grey
@onready var red = $frame/door/red
@onready var yellow = $frame/door/yellow
@onready var anim = $AnimationPlayer
@onready var locked_01 = $locked_01
@onready var locked_02 = $locked_02
@onready var locked_03 = $locked_03
@onready var locked_04 = $locked_04
@onready var opening = $open
@onready var close = $close
@onready var door = $frame/door

enum door_colours {
	Cyan,
	Grey,
	Red,
	Yellow
}

@export_category("Settings")
@export var colour: door_colours = door_colours.Cyan
@export var locked = false
##If enabled, the gate starts open.
@export var open_by_defualt = false

var prev_colour = null
var prev_open = false
var open = false
var selected = false

signal opened
signal closed

func _ready():
	if open_by_defualt:
		open = true
		door.rotation_degrees.y = 97.9
	else:
		open = false
		door.rotation_degrees.y = 0.0

func _process(delta):
	if Engine.is_editor_hint():
		if not prev_colour == colour:
			_set_colour(colour)
		prev_colour = colour
		if not prev_open == open_by_defualt:
			if open_by_defualt:
				open = true
				door.rotation_degrees.y = 97.9
			else:
				open = false
				door.rotation_degrees.y = 0.0
		prev_open = open_by_defualt

func _set_colour(colour):
	frame_cyan.visible = false
	frame_grey.visible = false
	frame_red.visible = false
	frame_yellow.visible = false
	cyan.visible = false
	grey.visible = false
	red.visible = false
	yellow.visible = false
	if colour == 0:
		frame_cyan.visible = true
		cyan.visible = true
	if colour == 1:
		frame_grey.visible = true
		grey.visible = true
	if colour == 2:
		frame_red.visible = true
		red.visible = true
	if colour == 3:
		frame_yellow.visible = true
		yellow.visible = true

func _on_hand_det_area_entered(area):
	if Player.l_launched:
		get_tree().call_group("player", "_retract_left")
		_toggle_door()

func _on_hand_det_r_area_entered(area):
	if Player.r_launched:
		get_tree().call_group("player", "_retract_right")
		_toggle_door()

func _on_item_det_area_entered(area):
	selected = true

func _on_item_det_area_exited(area):
	selected = false

func _input(event):
	if Input.is_action_just_pressed("use") and selected:
		_toggle_door()

func _lock_sfx():
	var path = str("locked_0", randi_range(1, 4))
	var node = get_node(path)
	node.play()

func _toggle_door():
	if locked:
		_lock_sfx()
		anim.play("locked")
	else:
		if not open:
			opening.play()
			anim.play("open")
			open = true
		else:
			close.play()
			anim.play_backwards("open")
			open = false

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		emit_signal("opened")
	if anim_name == "close":
		emit_signal("closed")
