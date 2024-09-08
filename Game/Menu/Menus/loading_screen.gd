extends CanvasLayer

signal loading_screen_has_full_coverage

@onready var animation_player : AnimationPlayer = $AnimationPlayer

var load_value = 0.0

func _update_progress_bar(new_value: float) -> void:
	load_value = new_value * 100
	if load_value == 100:
		_start_outro_animation()

func _start_outro_animation() -> void:
	animation_player.play("end_load")
	await Signal(animation_player, "animation_finished")
	self.queue_free()
