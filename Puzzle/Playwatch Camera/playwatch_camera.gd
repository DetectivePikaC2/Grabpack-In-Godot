extends Camera3D

signal obstacle_openned

@export var play_puzzle_complete_sound = false
enum sound_version {
	puzzle_complete,
	grabpack_jingle,
}
@export var complete_sound: sound_version = sound_version.puzzle_complete

@onready var puzzle_sfx: AudioStreamPlayer = $puzzle_sfx
@onready var jingle: AudioStreamPlayer = $jingle

var openned = false

func _open_obstacle():
	if not openned:
		emit_signal("obstacle_openned")
		if play_puzzle_complete_sound:
			if complete_sound == 0:
				puzzle_sfx.play()
			else:
				jingle.play()
		openned = true
