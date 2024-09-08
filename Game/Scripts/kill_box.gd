@tool
extends Area3D
class_name KillBox

var collision:CollisionShape3D

func _ready():
	body_entered.connect(Callable(self,"_murder_attempt"))

func _enter_tree() -> void:
	if get_node("CollisionShape3D") == null:
		collision = CollisionShape3D.new()
		add_child(collision)
		collision.set_owner(get_tree().edited_scene_root)
		collision.name = "CollisionShape3D"
		collision.shape = BoxShape3D.new()

func _murder_attempt(body: CharacterBody3D) -> void:
	if body.is_in_group("player"):
		Game.kill_player()
