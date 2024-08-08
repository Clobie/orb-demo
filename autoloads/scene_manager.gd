extends CanvasLayer

@onready var loading_screen_preload = preload("res://scenes/loading/loading_screen.tscn")
@onready var loading_screen

func _ready():
	loading_screen = loading_screen_preload.instantiate()
	add_child(loading_screen)

func _process(delta):
	pass

func fade_to_scene(scene_path):
	get_tree().change_scene_to_file(scene_path)
	loading_screen.end()

func reveal():
	loading_screen.end()
