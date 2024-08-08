extends Node

@onready var current_music_path = ""
@onready var current_music_player = $MusicSFX1
@onready var arcane_sfx = $ArcaneSFX

# TODO: set defaults and add to settings menu
@onready var master_bus_db = 0
@onready var music_bus_db = -10
@onready var sfx_bus_db = 0

func _ready():
	pass

func play_arcane_hit_sfx(pos: Vector2):
	arcane_sfx.position = pos
	$ArcaneSFX.play()

func get_next_music_player():
	if current_music_player == $MusicSFX1:
		return $MusicSFX2
	else:
		return $MusicSFX1

func get_current_music_player():
	return current_music_player
	
func cycle_current_music_player():
	if current_music_player == $MusicSFX1:
		current_music_player = $MusicSFX2
	else:
		current_music_player = $MusicSFX1

func play_music(path):
	if current_music_player.playing and current_music_path != path:
		current_music_player.stop()
	else:
		if current_music_path != path:
			current_music_player.stream = load(path)
			current_music_player.play()
			current_music_path = path

func fade_to_track(path):
	var curr = get_current_music_player()
	if !curr.playing:
		play_music(path)
	else:
		if current_music_path != path:
			var next = get_next_music_player()
			next.stream = load(path)
			next.volume_db = -50
			next.play()
			if curr == $MusicSFX1:
				$AnimationPlayer.play("MusicSFX1_to_MusicSFX2")
			else:
				$AnimationPlayer.play("MusicSFX2_to_MusicSFX1")
			cycle_current_music_player()
			current_music_path = path
