extends Node2D

func _ready():
	$GPUParticles2D.emitting = true

func _on_gpu_particles_2d_finished():
	call_deferred("queue_free")
