extends CanvasLayer

@onready var button_back = $MarginContainer2/VBoxContainer/Button_Back

func _ready():
	pass

func _on_button_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/start_menu/startmenu.tscn")
