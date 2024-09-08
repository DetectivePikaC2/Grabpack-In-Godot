extends Node3D

@export var sway_rotation_amount: float = 0.005
@export var sway_rotation_smoothness: float = 12.0
@export var item_path: NodePath = "scale"

@onready var item: Node3D = get_node(item_path)

var original_rotation: Vector3

func _ready():
	if item:
		original_rotation = item.rotation_degrees

func _process(delta):
	if item and not Player.use_mobile and Player.can_move:
		handle_sway(delta)

func handle_sway(delta):
	var mouse_velocity = Input.get_last_mouse_velocity()
	
	var sway_rotation_x = 0 - mouse_velocity.y * sway_rotation_amount
	var sway_rotation_y = mouse_velocity.x * sway_rotation_amount

	var sway_rotation = Vector3(sway_rotation_x, sway_rotation_y, 0)
	var target_rotation = original_rotation + sway_rotation
	item.rotation_degrees = lerp(item.rotation_degrees, target_rotation, sway_rotation_smoothness * delta)
