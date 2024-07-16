extends StaticBody3D

@onready var anim = $AnimationPlayer
@onready var gate_open = $gate_open

var open = false

signal opened
signal closed

func _open():
	anim.play("open")
	gate_open.play()
	open = true

func _close():
	anim.play("close")
	gate_open.play()
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
