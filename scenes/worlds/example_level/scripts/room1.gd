extends Node2D

@onready var directional_light_2d_darkness = $Lights/DirectionalLight2D_Darkness
@onready var level_music_path = "res://assets/audio/DavidKBD/6- The Veil of Night.ogg"

var run = true

func _ready() -> void:
	directional_light_2d_darkness.visible = true
	AudioManager.fade_to_track(level_music_path)
	$Orbs/OrbLight.apply_impulse(Vector2(25, -7) / 5.0, Vector2(0, 0))
	
func _process(_delta: float) -> void:
	if run:
		var active = 0
		for orb in $Receptacles.get_children():
			if orb.activated:
				active += 1
		$CanvasLayer/Label.text = "Activated Orbs: " + str(active) + "/7"
		if active == 7:
			run = false
			$CanvasLayer/Label2.visible = true
			await get_tree().create_timer(2).timeout
			SceneManager.fade_to_scene("res://scenes/menus/start_menu/startmenu.tscn")
