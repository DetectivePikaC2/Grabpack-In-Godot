@tool
extends Node3D
class_name RaceCarObject

var collision:CollisionShape3D
var area:Area3D
var sfx:AudioStreamPlayer3D

@export var play_break_sound = true
@export var object: RigidBody3D = null
#@export var break_particles = false

@onready var area_3d = $Area3D
@onready var audio_crash = $AudioStreamPlayer3D

const CRASH_SFX: AudioStream = preload("res://Puzzle/Race Car/SFX/SW_WindupCar_RubbleCrash.wav")

var broken = false

func _ready() -> void:
	area_3d.area_entered.connect(Callable(self,"_destroy"))
	audio_crash.finished.connect(Callable(self,"_delete"))
	object.freeze = true

func _enter_tree() -> void:
	if get_node("Area3D") == null:
		collision = CollisionShape3D.new()
		area = Area3D.new()
		sfx = AudioStreamPlayer3D.new()
		add_child(area)
		add_child(sfx)
		area.add_child(collision)
		collision.set_owner(get_tree().edited_scene_root)
		area.set_owner(get_tree().edited_scene_root)
		sfx.set_owner(get_tree().edited_scene_root)
		area.collision_layer = 512
		area.collision_mask = 512
		collision.name = "CollisionShape3D"
		area.name = "Area3D"
		sfx.name = "AudioStreamPlayer3D"
		sfx.stream = CRASH_SFX
		collision.shape = BoxShape3D.new()

func _destroy(area: Area3D):
	if area.is_in_group("car_breaker") and not broken:
		reparent(get_parent().get_parent())
		var obj_col = object.get_node("COLLIDER")
		obj_col.queue_free()
		object.freeze = false
		if play_break_sound:
			audio_crash.play()
		else:
			_delete()
		broken = true

func _delete() -> void:
	object.queue_free()
	queue_free()
