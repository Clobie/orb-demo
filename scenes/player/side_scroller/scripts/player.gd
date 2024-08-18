extends CharacterBody2D

@onready var state_machine = $StateMachine

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@onready var ledge_top_ray: RayCast2D = $Rays/RayCast2D_Ledge0
@onready var ledge_mid_ray: RayCast2D = $Rays/RayCast2D_Ledge1
@onready var wall_mid_ray: RayCast2D = $Rays/RayCast2D_Wall1
@onready var floor_mid_ray = $Rays/RayCast2D_Floor1
@onready var camera_2d = $Camera2D
@onready var projectile = preload("res://scenes/projectiles/energy_projectile/energy_projectile.tscn")
@onready var start_pos = global_position
@onready var timer_can_shoot = $Timer_CanShoot

@export var health = 150
@onready var health_max = health

@export var energy = 100
@onready var energy_max = energy

var rope: Node2D
var rope_target: Node2D

var can_shoot = true


var controllable: bool = true
var can_jump: bool = true
var can_double_jump: bool = true
var can_wall_jump: bool = true
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jump_force: float = 350.0 # 3.5 blocks
var double_jump_force: float = 300.0 # 3 blocks
var run_speed: float = 11000.0 # why is this so high
var threshold = 0.5
var look_dir: int = 1

var grav_gun_enabled = false
var grappling = []
var grappling_last_force = []

var push_force_base = 1.0
var current_platform

func _ready() -> void:
	$Area2D/CollisionShape2D/Sprite2D.visible = false
	$Node2D/ProgressBar_Green.value = health
	$Node2D/ProgressBar_Green.max_value = health_max
	$Node2D/ProgressBar_Red.value = health
	$Node2D/ProgressBar_Red.max_value = health_max
	heal(9999)
	
	$Node2D2/ProgressBar_Yellow.value = energy_max
	

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		grav_gun(true)
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if can_shoot:
			shoot_projectile()
			can_shoot = false
			timer_can_shoot.start()
			
	if !grappling.is_empty():
		var i = -1
		for item in grappling:
			i += 1
			if item.has_method("can_grapple"):
				if item.can_grapple:
					var tpos = $Area2D/CollisionShape2D.global_position
					var opos = item.global_position
					var force = clamp(tpos.distance_to(opos), 0, 50)
					var dir = (tpos - opos).normalized()
					item.do_force(dir * force)
					grappling_last_force[i] = dir

func grav_gun(enable: bool):
	if enable:
		#var pos = global_position
		$Area2D/CollisionShape2D.global_position = get_global_mouse_position()
		if grav_gun_enabled == false:
			$Area2D/CollisionShape2D.set_deferred("disabled", false)
			$Area2D/CollisionShape2D/Sprite2D.visible = true
			grav_gun_enabled = true
	else:
		$Area2D/CollisionShape2D.global_position = global_position
		$Area2D/CollisionShape2D.set_deferred("disabled", true)
		$Area2D/CollisionShape2D/Sprite2D.visible = false
		grav_gun_enabled = false
		grappling = []
		grappling_last_force = []

func shoot_projectile():
	if energy > 10:
		energy = clamp(energy - 10, 0, energy_max)
		$Node2D2/ProgressBar_Yellow.value = energy
		var startpos = global_position - Vector2(0, 20)
		var mouse_position = get_global_mouse_position()
		var direction = (mouse_position - startpos).normalized()
		startpos = startpos + direction * 5
		var p = projectile.instantiate()
		p.global_position = startpos
		p.direction = direction
		p.parent = $"."
		get_tree().current_scene.add_child(p)

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			#if event.button_index == 1:
				#shoot_projectile()
			if event.button_index == 2:
				pass
		if event.is_released:
			grav_gun(false)

func move_axis() -> float:
	var axis = Input.get_axis("left", "right")
	look_dir = 0 if abs(axis) < threshold else (1 if axis > 0 else -1)
	if look_dir != 0:
		anim.scale.x = anim.scale.y * look_dir
		ledge_top_ray.target_position.y =  9 * look_dir
		ledge_mid_ray.target_position.y = 7.1 * look_dir
		wall_mid_ray.target_position.y = 7.1 * look_dir
		return look_dir
	return 0

func jump() -> bool:
	if !controllable:
		return false
	return can_jump and (is_on_wall() or is_on_floor()) and Input.is_action_just_pressed("jump")

func double_jump() -> bool:
	if !controllable:
		return false
	return can_double_jump and Input.is_action_just_pressed("jump")

func wall_jump() -> bool:
	if !controllable:
		return false
	return can_wall_jump and (is_on_wall() or ledge_mid_ray.is_colliding() or ledge_top_ray.is_colliding()) and Input.is_action_just_pressed("jump")

# disabled for now
func shoot() -> bool:
	return false

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func can_ledge_hold():
	if !ledge_top_ray.is_colliding() and ledge_mid_ray.is_colliding() and wall_mid_ray.is_colliding():# and move_axis() != 0:
		return true
	return false

func can_wall_hold():
	if ledge_top_ray.is_colliding() and ledge_mid_ray.is_colliding() and wall_mid_ray.is_colliding() and Input.is_action_pressed("up"):
		return true
	return false

func can_floor_hold():
	if floor_mid_ray.is_colliding() and is_on_floor():
		if current_platform == floor_mid_ray.get_collider():
			return true
	return false

func get_floor_collider():
	if floor_mid_ray.is_colliding():
		return floor_mid_ray.get_collider()
	return null

func is_crouching():
	return Input.is_action_pressed("down")

func get_rope_point():
	return $Marker2D_RopePoint.global_position

func die():
	state_machine.set_state("death")

func respawn():
	health = health_max
	$Node2D/ProgressBar_Green.value = health
	$Node2D/ProgressBar_Red.value = health

func take_damage(amount):
	if amount > 0:
		health = clamp(health - amount, 0, health_max)
		$Node2D/ProgressBar_Green.value = health
		create_tween().tween_property($Node2D/ProgressBar_Red, "value", health, 0.5)
	if health <= 0:
		die()

func heal(amount):
	if amount > 0:
		health = clamp(health + amount, 0, health_max)
		$Node2D/ProgressBar_Green.value = health
		$Node2D/ProgressBar_Red.value = health
	
func _on_area_2d_body_entered(body):
	if body.has_method("can_grapple"):
		if body.can_grapple():
			grappling.push_back(body)
			grappling_last_force.push_back(Vector2(0,0))

func _on_area_2d_body_exited(body):
	if body.has_method("can_grapple"):
		if body.can_grapple():
			var i = -1
			for item in grappling:
				i += 1
				if item == body:
					grappling.remove_at(i)

func _on_timer_can_shoot_timeout():
	can_shoot = true
	timer_can_shoot.stop()

func _on_timer_energy_regen_timeout():
	energy = clamp(energy + 2, 0, energy_max)
	$Node2D2/ProgressBar_Yellow.value = energy
