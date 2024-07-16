extends StaticBody3D

func _destroy():
	queue_free()

func _on_area_3d_area_entered(area):
	_destroy()
