extends StaticBody3D

@export_category("Settings")
##Video file of the video this tv plays
@export var video: VideoStream = null
##If enabled, this tv uses spatial audio
@export var use_spatial_audio = false
##Audio file for spatial audio to play if use_spatial_audio is enabled
@export var audio: AudioStream = null

@onready var video_player = $_0/SubViewportContainer/SubViewport/video
@onready var spatial_audio = $spatial_audio

var played = false

signal tape_finished

func _ready():
	video_player.stream = video
	if use_spatial_audio:
		spatial_audio.stream = audio

func _play():
	if not played:
		video_player.play()
		if use_spatial_audio:
			video_player.volume_db = -80
			spatial_audio.play()
		played = true

func _on_video_finished():
	emit_signal("tape_finished")
