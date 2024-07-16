extends StaticBody3D

@onready var launch = $launch

@export var launch_height = 10.0

func _on_right_col_area_entered(area):
	if Player.current_hand == 3:
		#REMEMBER TO MAKE THE HIEGHT BASED ON DISTANCE TO PLAYER
		launch.play()
		get_tree().call_group("player", "_retract_right")
		get_tree().call_group("player", "_jump", launch_height)
