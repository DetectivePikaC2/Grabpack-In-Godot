extends CharacterBody3D

@export var speed = 2.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var head_bone: BoneAttachment3D = $head_bone
@onready var head_offset: Marker3D = $head_offset

var enabled = false
var prev_look

const LERP_SPEED = 10.0

func _ready() -> void:
	prev_look = transform.origin + velocity

func _process(delta: float) -> void:
	if enabled:
		_update_target_location(Player.player_transform)

func _physics_process(delta):
	if enabled:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		
		prev_look = lerp(prev_look, global_transform.origin + velocity, LERP_SPEED * delta)
		look_at(prev_look)
		
		velocity = new_velocity
		move_and_slide()
		head_bone.look_at(Player.player_position)
		head_bone.rotation -= head_offset.rotation

func _update_target_location(target_location):
	nav_agent.target_position = target_location

func _on_spawn_cooldown_timeout() -> void:
	enabled = true
