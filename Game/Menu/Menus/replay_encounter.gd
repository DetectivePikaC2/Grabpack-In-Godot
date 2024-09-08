extends Control

@onready var replaytitle = $replaytitle
@onready var replay_image = $replay_image
var target_level: String
@onready var animation_player = $AnimationPlayer

func _ready():
	visible = false

func _open_replay() -> void:
	visible = true
	animation_player.play("open")
	get_node("level1")._pressed()

func _close_replay() -> void:
	animation_player.play("close")

func _on_back_pressed():
	_close_replay()

func _load_replay(title: String, image: Texture2D, levelpath: String):
	target_level = levelpath
	replaytitle.text = title
	replay_image.texture = image

func _on_load_pressed():
	LoadManagement.load_scene(target_level)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "close":
		visible = false
