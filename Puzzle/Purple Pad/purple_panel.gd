extends StaticBody3D

@onready var launch = $launch
@onready var sm_jump_pad: MeshInstance3D = $SM_Jump_Pad_mo_Material_052_0_4/SM_Jump_Pad
@onready var light: OmniLight3D = $OmniLight3D
@onready var mark: Marker3D = $mark
@onready var cooldown: Timer = $cooldown

@export var launch_height = 10.0
@export var powered = true

var on_cooldown = false

func _ready() -> void:
	_set_emission(powered)

func _toggle_power() -> void:
	if powered:
		_unpower()
	else:
		_power()

func _power() -> void:
	powered = true
	_set_emission(powered)

func _unpower() -> void:
	powered = false
	_set_emission(powered)

func _set_emission(new_em: bool) -> void:
	var mat = sm_jump_pad.get_surface_override_material(0)
	mat.emission_enabled = new_em
	light.visible = new_em

func _on_right_col_area_entered(area):
	if Player.current_hand == 3 and powered and not on_cooldown:
		var true_height = launch_height - global_position.distance_to(Player.player_position) + 1.0
		if true_height < 0:
			true_height = 0
		launch.play()
		get_tree().call_group("player", "_jump", true_height)
		get_tree().call_group("player", "_update_r_rotation", mark.global_rotation, true, false, false)
		cooldown.start()
		on_cooldown = true

func _on_cooldown_timeout() -> void:
	on_cooldown = false
