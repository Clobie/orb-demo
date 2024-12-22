extends Node2D


var time = 0.0
var timeout = 1.0

var chaintime = 0.0
var chaintimeout = 0.1

var exploded = false

var chain_right = true
var chain_left = true

var sound_played = false

var chained = false
@onready var ray_cast_2d_left = $RayCast2D_Left
@onready var ray_cast_2d_right = $RayCast2D_Right
@onready var ray_cast_2d_down_right = $RayCast2D_DownRight
@onready var ray_cast_2d_down_left = $RayCast2D_DownLeft

@onready var audio_stream_player_2d = $AudioStreamPlayer2D


const GROUND_EXPLOSION = preload("res://scenes/spell_attacks/ground_explosion.tscn")

func _ready():
	$AnimatedSprite2D.play("start")

func _physics_process(delta):
	time += delta
	chaintime += delta
	if time > timeout and !exploded:
		exploded = true
		$AnimatedSprite2D.play("explode")
	if exploded:
		if $AnimatedSprite2D.frame == 1:
			$Area2D/CollisionShape2D.disabled = false
			if !sound_played:
				audio_stream_player_2d.play()
				sound_played = true
		if $AnimatedSprite2D.frame == 5:
			$Area2D/CollisionShape2D.disabled = true
		if $AnimatedSprite2D.frame == 8:
			visible = false
	if !chained and chaintime > chaintimeout:
		chaintime = 0.0
		chained = true
		_chain()
		
func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(25)

func _chain():
	if chain_left:
		if !ray_cast_2d_left.is_colliding() and ray_cast_2d_down_left.is_colliding():
			var att = GROUND_EXPLOSION.instantiate()
			att.global_position = global_position + Vector2(-35, 0)
			att.chain_left = true
			att.chain_right = false
			get_tree().root.add_child(att)
	if chain_right:
		if !ray_cast_2d_right.is_colliding() and ray_cast_2d_down_right.is_colliding():
			var att = GROUND_EXPLOSION.instantiate()
			att.global_position = global_position + Vector2(35, 0)
			att.chain_right = true
			att.chain_left = false
			get_tree().root.add_child(att)

func _on_timer_timeout():
	call_deferred("queue_free")
