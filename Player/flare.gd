extends Node3D

@onready var time = $time
@onready var light = $OmniLight3D
@onready var flare_ambience = $flare_ambience

var target_position = Vector3()
var fading = false

var new_flare = true

func _enter_tree():
	target_position = Player.flare_spawn_position

func _process(delta):
	if not global_position.distance_to(target_position) < 0.3:
		global_position = global_position.move_toward(target_position, 20.0 * delta)
		target_position.y -= 0.0005
	if fading:
		light.light_energy -= 0.025
		flare_ambience.volume_db -= 0.1
	if light.light_energy < 0:
		queue_free()

func _delete_flare():
	queue_free()

func _on_time_timeout():
	fading = true

func _on_new_timeout():
	new_flare = false
