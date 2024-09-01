extends Camera3D

signal obstacle_openned

var openned = false

func _open_obstacle():
	if not openned:
		emit_signal("obstacle_openned")
		openned = true
