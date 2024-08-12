extends CharacterBody2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var statemachine = $StateMachine

@export var health = 100
@onready var health_max = health

@export var roam_speed = 3000
@export var chase_speed = 12000

@onready var ray_cast_2d_farleft = $Rays/RayCast2D_FarLeft
@onready var ray_cast_2d_farright = $Rays/RayCast2D_FarRight
@onready var ray_cast_2d_right = $Rays/RayCast2D_Right
@onready var ray_cast_2d_left = $Rays/RayCast2D_Left
@onready var ray_cast_2d_floor_left = $Rays/RayCast2D_FloorLeft
@onready var ray_cast_2d_floor_right = $Rays/RayCast2D_FloorRight
@onready var ray_cast_2d_player_detector = $Rays/RayCast2D_PlayerDetector

var dead = false

func _process(delta):
	if health <= 0 and !dead:
		die()

func _physics_process(delta):
	pass
	
func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func take_damage(amount):
	if amount > 0:
		health = clamp(health - amount, 0, health_max)
		$Node2D/ProgressBar_Green.value = health
		create_tween().tween_property($Node2D/ProgressBar_Red, "value", health, 0.5)

func die():
	dead = true
	statemachine.set_state("death")
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	$Node2D.visible = false

func detect_player():
	var left = ray_cast_2d_farleft.is_colliding()
	var right = ray_cast_2d_farright.is_colliding()
	if left: return ray_cast_2d_farleft.get_collider()
	if right: return ray_cast_2d_farright.get_collider()
	return false

func on_edge():
	var left = ray_cast_2d_floor_left.is_colliding()
	var right = ray_cast_2d_floor_right.is_colliding()
	if (!left and right) or (left and !right):
		return true
	return false

func near_wall():
	var left = ray_cast_2d_left.is_colliding()
	var right = ray_cast_2d_right.is_colliding()
	if (!left and right) or (left and !right):
		return true
	return false

func _on_area_2d_attack_area_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(randi_range(15, 25))

func can_see_player(target):
	ray_cast_2d_player_detector.target_position = (target.global_position - global_position)
	return ray_cast_2d_player_detector.get_collider() == target

func get_target_seen_position():
	if ray_cast_2d_player_detector.is_colliding():
		return ray_cast_2d_player_detector.get_collider().global_position
	return null
