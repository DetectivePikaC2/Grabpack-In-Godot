extends Node

func tooltip(message: String, display_time: float) -> void:
	get_tree().call_group("player", "tooltip", message, display_time)

func set_objective(objective: String, display_time: float) -> void:
	get_tree().call_group("player", "new_objective", objective, display_time)

func kill_player() -> void:
	get_tree().call_group("player", "_die")
