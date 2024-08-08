class_name StateMachine_CharacterBody2D
extends Node

@export var state: State_CharacterBody2D

@onready var unit = get_parent() as CharacterBody2D
@onready var anim = unit.find_child("AnimatedSprite2D") as AnimatedSprite2D
@onready var debug = unit.find_child("debug") as TextEdit

var states: Dictionary

func _ready() -> void:
	for child in get_children():
		if child is State_CharacterBody2D:
			states[child.name] = child
	set_state(state.name)

func _process(delta: float) -> void:
	if state is State_CharacterBody2D:
		state.loop_process(delta)

func _physics_process(delta: float) -> void:
	if state is State_CharacterBody2D:
		state.loop_physics_process(delta)
	unit.move_and_slide()
	process_collisions(delta)

func process_collisions(_delta):
	for i in unit.get_slide_collision_count():
		var c = unit.get_slide_collision(i)
		var collider = c.get_collider()
		if collider is RigidBody2D:
			var normal = c.get_normal()
			if normal.angle_to(Vector2.UP) < 0.7853:	# 45 degrees in radians
				if unit.current_platform != collider:
					unit.current_platform = collider
				continue
			if collider is RigidBody2D:
				if collider.has_method("hit"):
					var pos = c.get_position()
					var force = unit.push_force_base + abs(unit.velocity.length()) / 500.0
					collider.hit(unit, pos, -normal * force)

func set_state(new_state: String):
	if states.has(new_state):
		state.exit_state()
		states[new_state].enter_state()
		state = states[new_state]

func get_state():
	return state
