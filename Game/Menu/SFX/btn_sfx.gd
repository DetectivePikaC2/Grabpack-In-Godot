extends Node
class_name ButtonSFXPlayer

@export var root_path : NodePath

@onready var sounds = {
	&"hover" : AudioStreamPlayer.new(),
	&"select" : AudioStreamPlayer.new(),
}


func _ready() -> void:
	assert(root_path != null, "Empty root path for UI Sounds!")
	
	#Setup
	for i in sounds.keys():
		sounds[i].stream = load("res://Game/Menu/SFX/" + str(i) + ".wav")
		#asign bus
		sounds[i].bus = &"UI"
		#ad to tree
		add_child(sounds[i])
	
	#connect signals to sfx
	install_sounds(get_node(root_path))


func install_sounds(node: Node) -> void:
	for i in node.get_children():
		if i is Button:
			i.mouse_entered.connect( func(): ui_sfx_play(&"hover"))
			i.pressed.connect( func(): ui_sfx_play(&"select"))
		
		#repeat
		install_sounds(i)

func ui_sfx_play(sound : StringName) -> void:
	sounds[sound].play()
