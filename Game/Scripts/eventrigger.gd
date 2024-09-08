@tool
extends Area3D
class_name EventTrigger

var collision:CollisionShape3D
signal triggered

##If enabled, this EventTrigger can only be triggered once
@export var disable_after_use = true

var event_triggered = false

func _ready():
	body_entered.connect(Callable(self,"_player_entered"))

func _enter_tree() -> void:
	if get_node("CollisionShape3D") == null:
		collision = CollisionShape3D.new()
		add_child(collision)
		collision.set_owner(get_tree().edited_scene_root)
		collision.name = "CollisionShape3D"
		collision.shape = BoxShape3D.new()

func _player_entered(body: CharacterBody3D) -> void:
	if body.is_in_group("player") and not event_triggered:
		emit_signal("triggered")
		event_triggered = true
