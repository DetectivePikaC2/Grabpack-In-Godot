extends Control

var paused = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		print(paused)
		if paused:
			_close_pause()
		else:
			_open_pause()

func _ready() -> void:
	visible = false

func _on_resume_pressed() -> void:
	_close_pause()

func _open_pause() -> void:
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	paused = true
	get_tree().paused = true
	animation_player.play("fade_in")

func _close_pause() -> void:
	visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	paused = false
	get_tree().paused = false

#BUTTON SIGNALS

func _on_titlescreen_pressed():
	get_tree().paused = false
	get_tree().call_group("player", "_disable_movement", true)
	LoadManagement.load_scene("res://Game/Menu/Menus/title_screen.tscn")

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().quit()
