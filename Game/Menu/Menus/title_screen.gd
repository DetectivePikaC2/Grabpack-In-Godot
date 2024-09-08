extends Control

@onready var replay_encounter = $replay_encounter

func _on_replay_pressed():
	replay_encounter._open_replay()

func _on_quit_pressed():
	get_tree().quit()
