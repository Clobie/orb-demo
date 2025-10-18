extends Node2D

# The scene to load after initialization
const NEXT_SCENE_PATH := "res://scenes/menus/start_menu/startmenu.tscn"

# Delay loading slightly to ensure shaders or heavy resources finish loading
var _load_delay := 1.0  # seconds
var _time := 0.0

func _ready() -> void:
	print("Loading shaders and preparing resources...")
	# You can preload your next scene here to reduce stutter later
	preload(NEXT_SCENE_PATH)

func _process(delta: float) -> void:
	_time += delta
	if _time >= _load_delay:
		print("Loading start menu...")
		get_tree().change_scene_to_file(NEXT_SCENE_PATH)
