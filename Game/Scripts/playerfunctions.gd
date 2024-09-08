extends Node

func tooltip(message: String, display_time: float) -> void:
	get_tree().call_group("player", "tooltip", message, display_time)

func set_objective(objective: String, display_time: float) -> void:
	get_tree().call_group("player", "new_objective", objective, display_time)

func kill_player() -> void:
	get_tree().call_group("player", "_die")

func _input(event):
	if Input.is_action_just_pressed("fullscreen"):
		if not DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
