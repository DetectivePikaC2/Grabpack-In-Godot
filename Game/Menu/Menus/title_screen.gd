extends Control

var settings_menu = false

@onready var replay_encounter = $replay_encounter
@onready var settings = $Settings

func _on_replay_pressed():
	replay_encounter._open_replay()

func _on_quit_pressed():
	get_tree().quit()

func _on_settings_pressed():
	if not settings_menu:
		settings._open_settings()
	else:
		settings._close_settings()
	settings_menu = !settings_menu
