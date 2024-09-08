@tool
extends StaticBody3D
class_name CardboardCutout

const BUTTON = preload("res://Puzzle/Button/button.tscn")
const MODEL_PARENT = preload("res://Puzzle/Cardboard/model_parent.tscn")
var audio: AudioStreamPlayer3D
var collision: CollisionShape3D

@export var cutout_lines: Array[AudioStream] = []
@export var audio_echo = false

@onready var audio_player = $AudioStreamPlayer3D
@onready var button = $Model_Parent/Button
@onready var animation_player = $Model_Parent/AnimationPlayer
var prev_image: Texture2D = null
var prev_size: float = 1

var last_played = 0

func _ready():
	button.pressed.connect(Callable(self,"_button_pressed"))

func _enter_tree():
	if get_node("Model_Parent") == null:
		var new_button = BUTTON.instantiate()
		audio = AudioStreamPlayer3D.new()
		collision = CollisionShape3D.new()
		var new_model = MODEL_PARENT.instantiate()
		add_child(audio)
		add_child(collision)
		add_child(new_model)
		audio.set_owner(get_tree().edited_scene_root)
		collision.set_owner(get_tree().edited_scene_root)
		new_model.set_owner(get_tree().edited_scene_root)
		audio.name = "AudioStreamPlayer3D"
		collision.name = "CollisionShape3D"
		new_model.name = "Model_Parent"
		new_model.add_child(new_button)
		new_button.set_owner(get_tree().edited_scene_root)
		new_button.name = "Button"

func _button_pressed() -> void:
	last_played += 1
	if last_played > cutout_lines.size():
		last_played = 1
	if audio_echo:
		audio_player.set_bus("Echo")
	else:
		audio_player.set_bus("Master")
	audio_player.stream = cutout_lines[last_played - 1]
	audio_player.play()
	animation_player.play("bobble")
