extends CanvasLayer

@onready var button_play = $MarginContainer/VBoxContainer/Button_Play
@onready var button_host = $MarginContainer/VBoxContainer/Button_Host
@onready var button_join = $MarginContainer/VBoxContainer/Button_Join
@onready var button_settings = $MarginContainer/VBoxContainer/Button_Settings
@onready var button_quit = $MarginContainer/VBoxContainer/Button_Quit
@onready var label_version = $MarginContainer2/Label_Version

func _ready():
	pass

func _on_button_play_pressed():
	pass

func _on_button_host_pressed():
	pass

func _on_button_join_pressed():
	pass

func _on_button_settings_pressed():
	pass

func _on_button_quit_pressed():
	get_tree().quit()
