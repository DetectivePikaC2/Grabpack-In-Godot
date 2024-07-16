extends Control

@onready var msg = $msg
@onready var tim = $tim
@onready var anim = $anim
@onready var audio = $audio

@export_category("Settings")
@export var death_messages = Array()

var msg_number = 0
var cycle = 0

func _ready():
	_load_message()

func _load_message():
	msg_number = randi_range(0, death_messages.size() - 1)
	msg.visible = false
	audio.play()
	tim.start()

func _on_tim_timeout():
	if cycle == 0:
		msg.visible = true
		msg.text = death_messages[msg_number][0]
		tim.start()
		cycle += 1
	elif cycle == 1:
		msg.text = death_messages[msg_number][1]
		tim.start(2.5)
		cycle += 1
	elif cycle == 2:
		anim.play("fade")

func _on_anim_animation_finished(anim_name):
	if anim_name == "fade":
		get_tree().change_scene_to_file(Player.previous_level)
