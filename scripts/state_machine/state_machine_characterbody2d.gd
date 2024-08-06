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

func set_state(new_state: String):
	if states.has(new_state):
		state.exit_state()
		states[new_state].enter_state()
		state = states[new_state]

		# Debugging
		if debug is TextEdit:
			debug.text = state.name

func get_state():
	return state
