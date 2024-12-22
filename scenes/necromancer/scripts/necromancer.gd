extends CharacterBody2D

var speed = 100
var speed_ramp = 500

var ray_length = 50

var engaged = false
@onready var staff_position = $StaffPosition

@onready var color_rect = $CanvasLayer/ColorRect

const HP_ORB = preload("res://scenes/gatherable/hp_orb.tscn")
const ENERGY_ORB = preload("res://scenes/gatherable/energy_orb.tscn")
const GROUND_EXPLOSION = preload("res://scenes/spell_attacks/ground_explosion.tscn")
const FIREBALL = preload("res://scenes/spell_attacks/fireball.tscn")
const SHURIKEN = preload("res://scenes/spell_attacks/shuriken.tscn")
const PORTAL_SPAWNER = preload("res://scenes/spell_attacks/portal_spawner.tscn")

@onready var audio_stream_player_2d_laugh_1 = $AudioStreamPlayer2D_Laugh1
@onready var audio_stream_player_2d_laugh_2 = $AudioStreamPlayer2D_Laugh2
@onready var audio_stream_player_2d_laugh_3 = $AudioStreamPlayer2D_Laugh3


@onready var label = $Chat/Label

var health_max = 3750
var health = health_max

@onready var target = get_tree().get_nodes_in_group("Player")[0]

@onready var ray_cast_2d_find_player = $Rays/RayCast2D_FindPlayer
@onready var ray_cast_2d_find_floor = $Rays/RayCast2D_FindFloor

@onready var ray_cast_2d_up = $Rays/RayCast2D_Up
@onready var ray_cast_2d_down = $Rays/RayCast2D_Down
@onready var ray_cast_2d_right = $Rays/RayCast2D_Right
@onready var ray_cast_2d_left = $Rays/RayCast2D_Left
@onready var point_light_2d = $PointLight2D
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	$Rays/RayCast2D_Up.target_position = Vector2(0, -1) * ray_length
	$Rays/RayCast2D_Down.target_position = Vector2(0, 1) * ray_length
	$Rays/RayCast2D_Right.target_position = Vector2(1, 0) * ray_length
	$Rays/RayCast2D_Left.target_position = Vector2(-1, 0) * ray_length
	SignalBus.level_complete_signal.connect(_on_level_complete)
	SignalBus.boss_spawn_point.connect(_on_boss_get_spawn_point)
	$CanvasLayer/ColorRect/ProgressBar_Red.max_value = health_max
	$CanvasLayer/ColorRect/ProgressBar_Red.value = health

func _on_level_complete():
	global_position = target.global_position + Vector2(-100, -50)
	$StateMachine.set_state("idle")
	$CanvasLayer/ColorRect.visible = true

func _on_boss_get_spawn_point(position):
	global_position = position
	
func _physics_process(delta):
	if target:
		if target.global_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true
			staff_position.position.x = -17
		if target.global_position.x > global_position.x:
			$AnimatedSprite2D.flip_h = false
			staff_position.position.x = 17
	else:
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
			staff_position.position.x = -17
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
			staff_position.position.x = 17
	
	var dr = (target.global_position - global_position).normalized()
	var dst = target.global_position.distance_to(global_position)
	
	ray_cast_2d_find_player.target_position = dr*dst*1.2
	ray_cast_2d_find_floor.global_position = target.global_position
	ray_cast_2d_find_floor.target_position = Vector2(0, 500)

func can_see_player():
	if ray_cast_2d_find_player.is_colliding():
		return ray_cast_2d_find_player.get_collider() == target
	return false

func floor_pos_below_target():
	if ray_cast_2d_find_floor.is_colliding():
		return ray_cast_2d_find_floor.get_collision_point()
	return null
	
func calculate_direction(bias_factor: float, include_target: bool = false, invert_target: bool = false) -> Vector2:
	var direction = Vector2.ZERO
	var raycasts = {
		"up": ray_cast_2d_up,
		"down": ray_cast_2d_down,
		"left": ray_cast_2d_left,
		"right": ray_cast_2d_right
	}
	for key in raycasts.keys():
		var raycast = raycasts[key]
		if raycast.is_colliding():
			var collision_point = raycast.get_collision_point()
			var global_pos = raycast.global_position
			var distance = collision_point.distance_to(global_pos)
			if key == "up":
				direction.y += bias_factor / distance
			elif key == "down":
				direction.y -= bias_factor / distance
			elif key == "left":
				direction.x += bias_factor / distance
			elif key == "right":
				direction.x -= bias_factor / distance
			if direction != Vector2.ZERO:
				direction = direction.normalized()
	if include_target and target:
		var tdir = (target.global_position - global_position).normalized()
		direction = (direction + (tdir * (1 if not invert_target else -0.2))).normalized()
	return direction

func get_biased_roam_direction() -> Vector2:
	return calculate_direction(1.0)

func get_biased_chase_direction() -> Vector2:
	return calculate_direction(1.0, true)

func get_biased_escape_direction() -> Vector2:
	return calculate_direction(1.0, true, true)
	
func take_damage(amount, p=null):
	if amount > 0:
		health = clamp(health - amount, 0, health_max)
		$CanvasLayer/ColorRect/ProgressBar_Red.value = health
		create_tween().tween_property($CanvasLayer/ColorRect/ProgressBar_Red, "value", health, 0.5)
	if health <= 0:
		$StateMachine.set_state("die")
