extends CharacterBody3D

@export var speed = 2.0

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var head_bone: BoneAttachment3D = $head_bone
@onready var head_offset: Marker3D = $head_offset
@onready var animation_player: AnimationPlayer = $plush_models/catnap_plush/AnimationPlayer
@onready var retreat: AudioStreamPlayer3D = $retreat
@onready var nearplayer: AudioStreamPlayer3D = $nearplayer
@onready var footstep: AudioStreamPlayer3D = $footstep
@onready var plush_models: Node3D = $plush_models
@onready var plush_flee: Marker3D = $plush_flee
@onready var head_camera: Camera3D = $plush_models/head_camera
@onready var jumpscare: AudioStreamPlayer3D = $jumpscare

var spawnpoint = global_transform.origin
var retreating = false
var jumpscaring = false

var enabled = false
var prev_look = transform.origin
var idle = false

const LERP_SPEED = 10.0

func _ready() -> void:
	prev_look = transform.origin + velocity
	spawnpoint = global_transform.origin

func _process(delta: float) -> void:
	if enabled:
		if retreating:
			_update_target_location(spawnpoint)
		else:
			_update_target_location(Player.player_transform)
			if global_position.distance_to(Player.player_position) < 3 and not idle:
				animation("idle", 2.0)
				footstep.stop()
				nearplayer.play()
				idle = true

func _physics_process(delta):
	if enabled:
		var current_location = global_transform.origin
		var next_location = nav_agent.get_next_path_position()
		var new_velocity = (next_location - current_location).normalized() * speed
		
		prev_look = lerp(prev_look, global_transform.origin + velocity, LERP_SPEED * delta)
		look_at(prev_look)
		
		velocity = new_velocity
		if not idle:
			move_and_slide()
		
		if not jumpscaring:
			head_bone.look_at(Player.player_position)
			head_bone.rotation -= head_offset.rotation

func _update_target_location(target_location):
	nav_agent.target_position = target_location

func animation(anim: String, speed: float) -> void:
	animation_player.speed_scale = speed
	animation_player.play(anim)

func _set_type(type: int) -> void:
	var checked_all = false
	var row = 0
	var base_critter_path = "plush_models/catnap_plush/Sketchfab_model/d79f4064f651479c9c8eb4dfbcc19567_fbx/Object_2/RootNode/critters_cat_skeleton/Object_6/Skeleton3D/p"
	var critter_path = str("plush_models/catnap_plush/Sketchfab_model/d79f4064f651479c9c8eb4dfbcc19567_fbx/Object_2/RootNode/critters_cat_skeleton/Object_6/Skeleton3D/p",type)
	while not checked_all:
		var critter_node = get_node(str(base_critter_path,row))
		if critter_node == null:
			checked_all = true
		else:
			critter_node.visible = false
		row += 1
	var critter_node = get_node(critter_path)
	critter_node.visible = true

#SIGNAL

func _on_spawn_cooldown_timeout() -> void:
	enabled = true

func _on_flare_area_entered(area: Area3D) -> void:
	if area.is_in_group("flare"):
		if not retreating and area.get_parent().new_flare:
			animation("flee", 4.0)
			footstep.play()
			nearplayer.stop()
			plush_models.rotation = plush_flee.rotation
			idle = false
			speed = speed * 4
			retreat.play()
			retreating = true

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "idle":
		if global_position.distance_to(Player.player_position) < 3:
			animation("jumpscare", 4.5)
			jumpscare.play()
			get_tree().call_group("player", "_disable_movement", true)
			head_camera.current = true
			jumpscaring = true
		else:
			animation("crawl", 1.0)
			footstep.play()
			idle = false
	if anim_name == "jumpscare":
		Game.kill_player()

func _on_navigation_agent_3d_navigation_finished() -> void:
	if retreating:
		queue_free()

func _on_jumpdet_body_entered(body):
	if body.is_in_group("player"):
		animation("jumpscare", 4.5)
		jumpscare.play()
		get_tree().call_group("player", "_disable_movement", true)
		head_camera.current = true
		jumpscaring = true
