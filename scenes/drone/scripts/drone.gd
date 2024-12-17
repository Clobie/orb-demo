extends CharacterBody2D

var speed = 50
var speed_ramp = 150
var horizontal_speed_multiplier = 2.0
var vertical_speed_multiplier = 0.25

var chase_distance = 350
var chase_speed = 125
var chase_speed_ramp = 250

var scan_attempts = 0
var max_scan_attempts = 3

var ray_length = 75

var target = null

@onready var timer_can_scan = $Timer_CanScan
var can_scan = true

@onready var laser = $Laser


@onready var prog_bar = $TextureProgressBar_Scanner

@onready var ray_cast_2d_up = $Rays/RayCast2D_Up
@onready var ray_cast_2d_down = $Rays/RayCast2D_Down
@onready var ray_cast_2d_right = $Rays/RayCast2D_Right
@onready var ray_cast_2d_left = $Rays/RayCast2D_Left

func _ready():
	$Rays/RayCast2D_Up.target_position = Vector2(0, -1) * ray_length
	$Rays/RayCast2D_Down.target_position = Vector2(0, 1) * ray_length
	$Rays/RayCast2D_Right.target_position = Vector2(1, 0) * ray_length
	$Rays/RayCast2D_Left.target_position = Vector2(-1, 0) * ray_length
	prog_bar.visible = false
	
func _physics_process(delta):
	if target:
		if target.global_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true
			$PointLight2D.position = Vector2(-4, 0)
			$Laser.position = Vector2(-4, 0)
		if target.global_position.x > global_position.x:
			$AnimatedSprite2D.flip_h = false
			$PointLight2D.position = Vector2(4, 0)
			$Laser.position = Vector2(4, 0)
	else:
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
			$PointLight2D.position = Vector2(-4, 0)
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
			$PointLight2D.position = Vector2(4, 0)
	
func get_biased_roam_direction():
	var direction = Vector2.ZERO
	var bias_factor = 1.0
	if ray_cast_2d_up.is_colliding():
		direction.y += (bias_factor / ray_cast_2d_up.get_collision_point().distance_to(ray_cast_2d_up.global_position))
	if ray_cast_2d_down.is_colliding():
		direction.y -= (bias_factor / ray_cast_2d_down.get_collision_point().distance_to(ray_cast_2d_down.global_position))
	if ray_cast_2d_left.is_colliding():
		direction.x += (bias_factor / ray_cast_2d_left.get_collision_point().distance_to(ray_cast_2d_left.global_position))
	if ray_cast_2d_right.is_colliding():
		direction.x -= (bias_factor / ray_cast_2d_right.get_collision_point().distance_to(ray_cast_2d_right.global_position))
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	if target:
		var tdir = (target.global_position - global_position).normalized()
		direction = (direction + tdir).normalized()
	return direction

func _on_area_2d_body_entered(body):
	if can_scan:
		can_scan = false
		target = body
		timer_can_scan.start()
	
func _on_timer_can_scan_timeout():
	can_scan = true
