extends Node3D

@onready var gate = $puzzle/Gate
@onready var gate_2 = $puzzle/Gate2
@onready var player = $Player
@onready var gate_3: StaticBody3D = $puzzle/Gate3
@onready var purple_panel_4: StaticBody3D = $puzzle/purple_panel4
@onready var gate_4: StaticBody3D = $puzzle/Gate4
@onready var gate_5: StaticBody3D = $puzzle/Gate5
@onready var gate_6: StaticBody3D = $puzzle/Gate6
@onready var gate_7 = $puzzle/Gate7
@onready var large_gate = $"puzzle/Large Gate"
@onready var mini_critter_spawner = $Critters/MiniCritterSpawner

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
	Game.tooltip("With the purple hand active, press the jump pad", 5)

func _on_grabpack_item_collected():
	Game.set_objective("Explore", 5)
	Game.tooltip("Use keys 1-4 or MOUSE SCROLL to switch hands", 5)


func _on_large_button_pressed():
	gate_3._open()
	purple_panel_4._power()

func _on_large_button_released():
	gate_3._close()
	purple_panel_4._unpower()


func _on_playwatch_camera_obstacle_openned() -> void:
	gate_4._open()

func _on_playwatch_camera_2_obstacle_openned() -> void:
	gate_5._open()

func _on_playwatch_camera_3_obstacle_openned() -> void:
	gate_6._open()

func _on_blue_scanner_2_scan_complete():
	gate_7._open()


func _on_playwatch_collected():
	Game.tooltip("press t to use cameras", 3)

func _on_event_trigger_triggered():
	Game.set_objective("find the coordinate device", 5)


func _on_power_reciever_power_recieved():
	large_gate._open()

func _on_event_trigger_3_triggered():
	mini_critter_spawner.spawner_active = true

func _on_event_trigger_4_triggered():
	mini_critter_spawner.spawner_active = false
