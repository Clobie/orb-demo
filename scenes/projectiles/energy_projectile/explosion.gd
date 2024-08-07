extends Node2D

func _ready():
	$GPUParticles2D.emitting = true
	AudioManager.play_arcane_hit_sfx(global_position)

func _on_gpu_particles_2d_finished():
	call_deferred("queue_free")
