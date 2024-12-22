extends Node2D

const SKELETON_2 = preload("res://scenes/skeleton2/skeleton2.tscn")
const SLIME = preload("res://scenes/slime/slime.tscn")

var total_to_spawn = 3
var spawned = 0

func _on_timer_timeout():
	spawned += 1
	spawn_random()
	if spawned == 3:
		var t = create_tween().tween_method(func(value): $Sprite2D.material.set_shader_parameter("alpha", value), 1.0, 0.0, 0.5)
		await t.finished
		call_deferred("queue_free")

func spawn_random():
	var mobs = [SLIME, SKELETON_2]
	var random_index = randi() % mobs.size()
	var unit = mobs[random_index].instantiate()
	unit.global_position = global_position
	get_tree().root.add_child(unit)
	
