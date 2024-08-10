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

@export var rope_scene: PackedScene
var rope: Node2D
var rope_target: Node2D

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

@export var health = 100
@onready var max_health = health

var push_force_base = 1.0
var current_platform

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

func shoot_projectile():
	var startpos = global_position - Vector2(0, 20)
	var mouse_position = get_global_mouse_position()
	var direction = (mouse_position - startpos).normalized()
	startpos = startpos + direction * 5
	var p = projectile.instantiate()
	p.global_position = startpos
	p.direction = direction
	get_tree().current_scene.add_child(p)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == 1:
			shoot_projectile()
		if event.button_index == 2:
			position = get_global_mouse_position()
			velocity = Vector2(0,0)
	if Input.is_action_pressed("mouse_wheel_down") or Input.is_action_pressed("mouse_wheel_up"):
		shoot_projectile()

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
	if ledge_top_ray.is_colliding() and ledge_mid_ray.is_colliding() and wall_mid_ray.is_colliding():# and move_axis() != 0:
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
