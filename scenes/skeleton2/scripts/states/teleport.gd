extends State_CharacterBody2D

# unit: CharacterBody2D
# statemachine: StateMachine
# anim: AnimatedSprite2D
# anim_name: String

var dir = 0
var destination: Vector2

func _ready():
	super()
	anim_name = "idle"

func enter_state():
	super()
	anim.play(anim_name)
	unit.velocity.x = 0
	unit.velocity.y = 0
	destination = unit.target.global_position
	disappear()
	await get_tree().create_timer(0.5).timeout
	teleport()
	reappear()
	await get_tree().create_timer(0.5).timeout
	unit.set_collision_layer_value(2, true)
	statemachine.set_state("idle")
	
func exit_state():
	pass

func loop_physics_process(delta):
	unit.velocity.x = 0

func loop_process(delta):
	pass

func disappear():
	var material = $"../../AnimatedSprite2D".material
	unit.set_collision_layer_value(2, false)
	#unit.set_collision_layer_value(1, false)
	$"../../Area2D_HurtArea".set_collision_layer_value(2, false)
	$"../../Area2D_HurtArea".set_collision_mask_value(1, false)
	$"../../Area2D_HurtArea".set_collision_mask_value(2, false)
	$"../../Node2D/ProgressBar_Red".visible = false
	$"../../Node2D/ProgressBar_Green".visible = false
	$"../../Node2D/ColorRect".visible = false
	$"../../Node2D/ColorRect2".visible = false
	create_tween().tween_method(
		func(value): 
			material.set_shader_parameter("progress", value), 
			0.0, 
			1.0, 
			0.5
	)

func reappear():
	var material = $"../../AnimatedSprite2D".material
	#unit.set_collision_layer_value(1, true)
	$"../../Area2D_HurtArea".set_collision_layer_value(2, true)
	$"../../Area2D_HurtArea".set_collision_mask_value(1, true)
	$"../../Area2D_HurtArea".set_collision_mask_value(2, true)
	$"../../Node2D/ProgressBar_Red".visible = true
	$"../../Node2D/ProgressBar_Green".visible = true
	$"../../Node2D/ColorRect".visible = true
	$"../../Node2D/ColorRect2".visible = true
	create_tween().tween_method(
		func(value): 
			material.set_shader_parameter("progress", value), 
			1.0, 
			0.0, 
			0.5
	)

func teleport():
	unit.global_position = destination
