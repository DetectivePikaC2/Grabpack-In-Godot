extends Node3D

@onready var gate = $Doors_Gates/Gate
@onready var large_gate = $"Doors_Gates/Large Gate"
@onready var large_gate2 = $"Doors_Gates/Large Gate2"
@onready var gate2 = $Doors_Gates/Gate2
@onready var gate3 = $Doors_Gates/Gate3

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
