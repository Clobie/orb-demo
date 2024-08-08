extends RigidBody2D

@onready var hp = 500
@onready var hp_max = hp
@onready var scene = ""

func _ready():
	pass

func _process(_delta):
	pass

func take_damage(amount):
	if amount > 0:
		hp = clamp(hp - amount, 0, hp_max)
	if hp <= 0:
		call_deferred("queue_free")

func hit(_obj, gpos, dir):
	var lpos = global_position - gpos
	apply_impulse(dir * 200, -lpos)
	
