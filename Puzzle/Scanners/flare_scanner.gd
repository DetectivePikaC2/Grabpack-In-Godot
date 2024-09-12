extends StaticBody3D

signal scanned_flare

@onready var light = $light
@onready var sphere_001 = $flare_scanner/Sphere_001

var scanned = false
var green = "00ff00"
var red = "ff0000"

func _ready():
	sphere_001.visible = false
	light.light_color = red

func _scan() -> void:
	if not scanned:
		emit_signal("scanned_flare")
		light.light_color = green
		sphere_001.visible = true
		scanned = true

func _on_area_3d_area_entered(area):
	if area.is_in_group("flare") and not scanned:
		_scan()
		area.get_parent()._delete_flare()
