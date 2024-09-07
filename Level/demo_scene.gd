extends Node3D

@onready var gate = $puzzle/Gate
@onready var gate_2 = $puzzle/Gate2
@onready var player = $Player
@onready var large_gate_2 = $"puzzle/Large Gate2"

var gate_openned = false

func _ready():
	Game.set_objective("Find a grabpack", 5)

func _on_gate_closer_area_entered(area):
	if not gate_openned:
		gate._close()
		Game.dialog("hold blue hand on the scanner", 5)
		gate_openned = true


func _on_blue_scanner_scan_complete():
	gate_2._open()

func _on_hand_notify_area_entered(area):
	Game.dialog("With the purple hand active, press the jump pad", 5)

func _on_grabpack_item_collected():
	Game.set_objective("Explore", 5)
	Game.dialog("Use keys 1-4 or MOUSE SCROLL to switch hands", 5)


func _on_large_button_pressed():
	large_gate_2._open()

func _on_large_button_released():
	large_gate_2._close()
