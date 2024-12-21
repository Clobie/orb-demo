extends Node2D

@onready var directional_light_2d_darkness = $Lights/DirectionalLight2D_Darkness
@onready var level_music_path = "res://assets/audio/MindsEyePack/6- The Veil of Night.ogg"
@onready var boss_music_path = "res://assets/audio/DavidKBD/01 - DavidKBD - Purgatory Pack - Purgatory.ogg"
var level_complete = false


func _ready() -> void:
	directional_light_2d_darkness.visible = true
	AudioManager.fade_to_track(level_music_path)
	$Orbs/OrbLight.apply_impulse(Vector2(25, -7) / 5.0, Vector2(0, 0))
	SignalBus.boss_dead.connect(_on_boss_dead)

func _on_boss_dead():
	create_tween().tween_property($Lights/DirectionalLight2D_Darkness, "energy", 0.0, 3.0)
	#$Lights/DirectionalLight2D_Darkness.visible = false
	
func _process(_delta: float) -> void:
	if !level_complete:
		var active = 0
		for orb in $Receptacles.get_children():
			if orb.activated:
				active += 1
		$CanvasLayer/Label.text = "Activated Orbs: " + str(active) + "/7"
		if active == 1:
			level_complete = true
			$CanvasLayer/Label2.visible = true
			var t = create_tween().tween_property($CanvasLayer/Label2, "modulate", Color.TRANSPARENT, 5.0)
			await get_tree().create_timer(3.5).timeout
			AudioManager.fade_to_track(boss_music_path)
			await get_tree().create_timer(1.5).timeout
			$CanvasLayer/Label.visible = false
			$CanvasLayer/Label2.visible = false
			
			SignalBus.level_complete_signal.emit()
			SignalBus.boss_spawn_point.emit($BossroomSpawnPoint.global_position)
			AudioManager.fade_to_track(boss_music_path)
			#SceneManager.fade_to_scene("res://scenes/menus/start_menu/startmenu.tscn")
		
