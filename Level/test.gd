extends Node3D

@onready var gate = $Doors_Gates/Gate
@onready var large_gate = $"Doors_Gates/Large Gate"
@onready var large_gate2 = $"Doors_Gates/Large Gate2"
@onready var gate2 = $Doors_Gates/Gate2
@onready var gate3 = $Doors_Gates/Gate3
@onready var player: CharacterBody3D = $Player

var scan1 = false
var scan2 = false

func _on_green_reciever_power_recieved():
	large_gate.call("_open")

func _on_lever_pulled(direction):
	if direction:
		gate.call("_open")
	else:
		gate.call("_close")

func _on_blue_scanner_scan_complete():
	scan1 = true
	if scan1 and scan2:
		large_gate2.call("_open")

func _on_red_scanner_scan_complete():
	scan2 = true
	if scan1 and scan2:
		large_gate2.call("_open")

func _on_battery_socket_battery_placed():
	gate2.call("_open")

func _on_battery_socket_battery_removed():
	gate2.call("_close")

func _on_power_reciever_power_recieved():
	gate3.call("_open")

func _on_power_reciever_2_power_recieved():
	pass # Replace with function body.

func _on_playwatch_camera_obstacle_openned() -> void:
	print("openned_1")

func _on_playwatch_camera_2_obstacle_openned() -> void:
	print("openned_2")

func _on_collectable_hand_4_collected() -> void:
	player.new_objective("try out the purple jump pads", 5)

func _on_gate_opened() -> void:
	player.tooltip("you look g-g-great. Mm. Have you considered a-a bow, tho?", 5)
