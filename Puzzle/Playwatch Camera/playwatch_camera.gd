extends Camera3D

signal obstacle_openned

@export var proximity = true
@export var proximity_distance = 12.0
@export var play_puzzle_complete_sound = false
enum sound_version {
	puzzle_complete,
	grabpack_jingle,
}
@export var complete_sound: sound_version = sound_version.puzzle_complete

@onready var puzzle_sfx: AudioStreamPlayer = $puzzle_sfx
@onready var jingle: AudioStreamPlayer = $jingle
@onready var activated = $activated

@onready var map_icon: Sprite3D = $map_icon

var openned = false

func _ready() -> void:
	map_icon.visible = true

func _open_obstacle():
	if not openned:
		if global_position.distance_to(Player.player_position) < proximity_distance or not proximity:
			activated.play()
			emit_signal("obstacle_openned")
			if play_puzzle_complete_sound:
				if complete_sound == 0:
					puzzle_sfx.play()
				else:
					jingle.play()
			openned = true
		else:
			Game.tooltip("camera is too far", 2)
	else:
		Game.tooltip("obstacle is already open", 2)
