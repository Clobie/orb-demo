extends Node


@onready var music_sfx_1 = $MusicSFX1

@onready var arcane_sfx_1 = $ArcaneSFX1

func _ready():
	pass

func _process(delta):
	pass

func play_arcane_hit_sfx(pos: Vector2):
	arcane_sfx_1.position = pos
	arcane_sfx_1.play()

func play_music():
	music_sfx_1.play()
