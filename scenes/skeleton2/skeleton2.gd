extends CharacterBody2D

@onready var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var statemachine = $StateMachine

@export var health = 100
@onready var health_max = health

@export var roam_speed = 3000
@export var chase_speed = 12000
@export var detect_range = 300
@export var deaggro_range = 350

@onready var ray_cast_2d_right = $Rays/RayCast2D_Right
@onready var ray_cast_2d_left = $Rays/RayCast2D_Left
@onready var ray_cast_2d_floor_left = $Rays/RayCast2D_FloorLeft
@onready var ray_cast_2d_floor_right = $Rays/RayCast2D_FloorRight
@onready var ray_cast_2d_player_detector = $Rays/RayCast2D_PlayerDetector
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

const HP_ORB = preload("res://scenes/gatherable/hp_orb.tscn")
const ENERGY_ORB = preload("res://scenes/gatherable/energy_orb.tscn")

var death_sounds = [
	"res://assets/audio/DeadlyKombatFreeversion/bone_breaking_03.wav",
	"res://assets/audio/DeadlyKombatFreeversion/bone_breaking_53.wav",
	"res://assets/audio/DeadlyKombatFreeversion/guts_and_gore_59.wav"
]

var dead = false

var target: CharacterBody2D

func _ready():
	$Node2D/ProgressBar_Red.max_value = health_max
	$Node2D/ProgressBar_Green.max_value = health_max
	$Node2D/ProgressBar_Red.value = health
	$Node2D/ProgressBar_Green.value = health
	audio_stream_player_2d.stream = load(death_sounds[randi_range(0, 2)])
	
func _process(delta):
	if health <= 0 and !dead:
		die()

func _physics_process(delta):
	pass
	
func apply_gravity(delta) -> void:
	velocity.y += gravity * delta

func take_damage(amount, parent):
	if amount > 0:
		health = clamp(health - amount, 0, health_max)
		$Node2D/ProgressBar_Green.value = health
		create_tween().tween_property($Node2D/ProgressBar_Red, "value", health, 0.5)
		if !target:
			target = parent
	statemachine.set_state("hurt")
	
func die():
	dead = true
	statemachine.set_state("death")
	set_collision_layer_value(2, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	$Node2D.visible = false
	audio_stream_player_2d.play()
	
	for i in range(5):
		var hp = HP_ORB.instantiate()
		hp.global_position = global_position + Vector2(randf_range(-40, 40), randf_range(-40, 40))
		get_tree().root.add_child(hp)
	for i in range(5):
		var en = ENERGY_ORB.instantiate()
		en.global_position = global_position + Vector2(randf_range(-40, 40), randf_range(-40, 40))
		get_tree().root.add_child(en)

func on_ledge():
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

func _on_area_2d_detect_player_body_entered(body):
	if body is CharacterBody2D:
		target = body

func _on_area_2d_deaggro_body_exited(body):
	if body == target:
		target = null
