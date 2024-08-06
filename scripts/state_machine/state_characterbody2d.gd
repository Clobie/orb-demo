class_name State_CharacterBody2D
extends Node

@onready var statemachine = get_parent() as StateMachine_CharacterBody2D
@onready var anim_name = ""
@onready var unit = get_parent().get_parent() as CharacterBody2D
@onready var anim = get_parent().get_parent().find_child("AnimatedSprite2D") as AnimatedSprite2D

func _ready():
	if !statemachine is StateMachine_CharacterBody2D:
		print("Oops! Not a StateMachine")

func enter_state():
	pass

func exit_state():
	pass

func loop_physics_process(delta):
	pass

func loop_process(delta):
	pass
