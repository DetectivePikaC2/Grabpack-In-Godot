extends Button

@export var level_path: String
@export var image: Texture2D

func _ready():
	pressed.connect(Callable(self,"_pressed"))

func _pressed() -> void:
	var parent = get_parent()
	parent._load_replay(text, image, level_path)
