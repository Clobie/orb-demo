extends Node2D

@onready var directional_light_2d_darkness = $Lights/DirectionalLight2D_Darkness

@onready var level_music_path = "res://assets/audio/DavidKBD/05 - DavidKBD - Purgatory Pack - From the Dark Past.ogg"

func _ready() -> void:
	directional_light_2d_darkness.visible = true
	AudioManager.fade_to_track(level_music_path)

func _process(_delta: float) -> void:
	pass
