extends Marker3D
class_name MiniCritterSpawner

var spawn_time = 5.0
var current_spawn_time = 0.0

@export var spawner_active = true
@export var spawn_rarity: float = 15
@export var max_critters: int = 5

const MINICRITTER = preload("res://Character/ColorPlush/minicritter.tscn")

func _ready() -> void:
	spawn_time = randi_range(1, spawn_rarity)

func _process(delta: float) -> void:
	if spawner_active and get_child_count() < max_critters + 1:
		current_spawn_time += 1 * delta
		if current_spawn_time > spawn_time:
			_spawn_critter(randi_range(0, 6))
			spawn_time = randi_range(1, spawn_rarity)
			current_spawn_time = 0.0

func _spawn_critter(type):
	var new_critter = MINICRITTER.instantiate()
	add_child(new_critter)
	new_critter._set_type(type)
