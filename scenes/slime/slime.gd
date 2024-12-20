extends CharacterBody2D


const speed = 100
@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var target = null
@onready var chase_speed = 5000
@onready var chase_distance = 250
@onready var ray_cast_2d_floor = $RayCast2D_Floor
@onready var ray_cast_2d_wall = $RayCast2D_Wall

@onready var animated_sprite_2d = $AnimatedSprite2D

@export var health = 30
@onready var health_max = health

@onready var statemachine = $StateMachine

const HP_ORB = preload("res://scenes/gatherable/hp_orb.tscn")
const ENERGY_ORB = preload("res://scenes/gatherable/energy_orb.tscn")

func _ready():
	pass

func _physics_process(delta):
	var d = get_direction()
	$AnimatedSprite2D.flip_h = (d == 1)
	$Area2D2_AttackBox/CollisionShape2D.position = Vector2(10 * d, -10)
	$RayCast2D_Floor.position = Vector2(21 * d, -12)
	$RayCast2D_Wall.position = Vector2(14 * d, -6)
	$RayCast2D_Wall.target_position = Vector2(11 * d, 0)

func get_direction() -> int:
	if target:
		return -1 if target.global_position.x < global_position.x else 1
	return -1 if velocity.x < 0 else 1

func take_damage(amount, parent):
	animated_sprite_2d.material.set_shader_parameter("toggle", true)
	if amount > 0:
		health = clamp(health - amount, 0, health_max)
	statemachine.set_state("hurt")

func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func _on_area_2d_body_entered(body):
	target = body
