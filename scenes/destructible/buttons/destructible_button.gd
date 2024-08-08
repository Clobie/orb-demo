extends RigidBody2D

@onready var hp = 100
@onready var hp_max = hp
@onready var scene = ""

func _ready():
	pass

func _process(delta):
	pass

func take_damage(amount):
	if amount > 0:
		hp = clamp(hp - amount, 0, hp_max)
	if hp <= 0:
		if scene == "quit":
			get_tree().quit()
		else:
			if scene != "":
				get_tree().change_scene_to_file(scene)
			call_deferred("queue_free")

func hit(obj, gpos):
	var lpos = global_position - gpos
	apply_impulse(lpos, -lpos * 100)

func setup(text, tscn):
	$Label.text = text
	scene = tscn
	
