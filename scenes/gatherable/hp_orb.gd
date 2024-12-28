extends Node2D

var base_speed = 0
var additive_speed = 0

@onready var player = get_tree().get_nodes_in_group("Player")[0]
var value = 0

func _ready():
	var size = randf_range(1.25, 5)
	scale = Vector2(size, size) / 3
	value = round(1 + size)

func _process(delta):
	if(player):
		additive_speed += 10
		var target_pos = player.global_position + Vector2(0, -10)
		position += (target_pos - position).normalized() * (base_speed + additive_speed) * delta
		if position.distance_to(target_pos) < 15:
			call_deferred("queue_free")
			if player.has_method("heal"):
				player.heal(value)
				BattleText.display_heal(value, player.global_position + Vector2(0, -75))
