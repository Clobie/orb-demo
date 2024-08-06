extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

@onready var ledge_top_ray: RayCast2D = $Rays/RayCast2D_Ledge0
@onready var ledge_mid_ray: RayCast2D = $Rays/RayCast2D_Ledge1
@onready var wall_mid_ray: RayCast2D = $Rays/RayCast2D_Wall1

@onready var camera_2d = $Camera2D


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

var base_zoom: float = 2.0
var zoom_multiplier: float = 0.1


func _ready() -> void:
	pass

func _process(delta: float) -> void:
		pass
	#var speed = velocity.length()
	#var target_zoom = clamp(base_zoom - speed * zoom_multiplier, 1.8, base_zoom)
	#var current_zoom = camera_2d.zoom
	#current_zoom.x = lerp(current_zoom.x, target_zoom, 0.1)
	#current_zoom.y = lerp(current_zoom.y, target_zoom, 0.1)
	#camera_2d.zoom = current_zoom

func _physics_process(delta: float) -> void:
	pass

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
	if !controllable:
		return false
	return false#Input.is_action_pressed("mouse1")

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

func is_crouching():
	return Input.is_action_pressed("down")
