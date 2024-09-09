extends Control

func _ready():
	visible = false

func _open_settings():
	visible = true

func _close_settings():
	visible = false

func _on_button_pressed():
	_close_settings()
