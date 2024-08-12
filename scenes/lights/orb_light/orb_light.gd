extends RigidBody2D

@onready var hp = 50000
@onready var hp_max = hp
@onready var scene = ""

var enabled = true

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
	apply_impulse(dir * 50, -lpos)
	
func _on_area_2d_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(9999)

func can_grapple():
	return enabled

func can_insert():
	return true
	
func disable():
	enabled = false
	linear_velocity = Vector2(0, 0)
	$CollisionShape2D.set_deferred("disabled", true)

func do_force(force: Vector2):
	if enabled:
		apply_force(force, Vector2(0,0))
