@tool
extends StaticBody3D

@onready var frame_rail = $frame/rail
@onready var frame_rail_dam = $frame/rail_damaged
@onready var frame_red = $frame/red
@onready var frame_blue = $frame/blue
@onready var frame_yellow = $frame/yellow
@onready var rail = $frame/gate/rail
@onready var rail_dam = $frame/gate/rail_damaged
@onready var red = $frame/gate/red
@onready var blue = $frame/gate/blue
@onready var yellow = $frame/gate/yellow
@onready var anim = $AnimationPlayer
@onready var opening = $opening
@onready var close = $close
@onready var gate = $frame/gate

enum gate_colours {
	Rail,
	Damaged_Rail,
	Red,
	Blue,
	Yellow,
}

@export_category("Settings")
##Cosmetic of the gate.
@export var colour: gate_colours = gate_colours.Rail
##If enabled, the gate starts open.
@export var open_by_defualt = false

var prev_colour = null
var open = false

signal opened
signal closed

func _ready():
	if open_by_defualt:
		open = true
		gate.position.y = 2.612

func _process(delta):
	if not prev_colour == colour:
		_set_colour(colour)
	prev_colour = colour

func _set_colour(colour):
	frame_rail.visible = false
	frame_rail_dam.visible = false
	frame_red.visible = false
	frame_blue.visible = false
	frame_yellow.visible = false
	rail.visible = false
	rail_dam.visible = false
	red.visible = false
	blue.visible = false
	yellow.visible = false
	if colour == 0:
		frame_rail.visible = true
		rail.visible = true
	if colour == 1:
		frame_rail_dam.visible = true
		rail_dam.visible = true
	if colour == 2:
		frame_red.visible = true
		red.visible = true
	if colour == 3:
		frame_blue.visible = true
		blue.visible = true
	if colour == 4:
		frame_yellow.visible = true
		yellow.visible = true

func _open():
	opening.play()
	anim.play("open")
	open = true

func _close():
	close.play()
	anim.play("close")
	open = false

func _toggle():
	if open:
		_close()
	else:
		_open()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "open":
		emit_signal("opened")
	if anim_name == "close":
		emit_signal("closed")
