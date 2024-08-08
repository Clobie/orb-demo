extends CanvasLayer

@onready var loading_screen_preload = preload("res://scenes/loading/loading_screen.tscn")
@onready var loading_screen

@onready var next_scene_path = ""

func _ready():
	loading_screen = loading_screen_preload.instantiate()
	add_child(loading_screen)

func _process(delta):
	pass

func fade_to_scene(scene_path):
	next_scene_path = scene_path
	$AnimationPlayer.play("fade_to_scene")
	
func _fade_in():
	loading_screen.start()

func _fade_out():
	loading_screen.end()

func _load_next_scene():
	get_tree().change_scene_to_file(next_scene_path)
