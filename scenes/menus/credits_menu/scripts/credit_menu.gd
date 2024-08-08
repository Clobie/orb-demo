extends CanvasLayer

@onready var button_back = $MarginContainer2/VBoxContainer/Button_Back

func _ready():
	pass

func _on_button_back_pressed():
	SceneManager.fade_to_scene("res://scenes/menus/start_menu/startmenu.tscn")
