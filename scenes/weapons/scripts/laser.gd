extends RayCast2D

@onready var line = $Line2D
@onready var sparks = $Sparks
@onready var tick_timer = $TickTimer

const max_range = 2000
const base_dps = 150.0
const base_tps = 8
var is_hitting_target = false
var damage_value = 0

func _ready():
	set_physics_process(false)
	line.points[1] = Vector2.ZERO
	tick_timer.wait_time = 1.0 / base_tps
	damage_value = base_dps / base_tps
	$Line2D.visible = false

func _physics_process(delta):
	target_position = Vector2.RIGHT * max_range
	force_raycast_update()
	if is_colliding():
		target_position = to_local( get_collision_point() )
		sparks.position = target_position
		sparks.emitting = true
		if not is_hitting_target:
			tick_timer.start()
			is_hitting_target = true
	else:
		sparks.emitting = false
		tick_timer.stop()
		is_hitting_target = false
	line.points[1] = target_position

func activate():
	set_physics_process(true)
	$Line2D.visible = true

func deactivate():
	set_physics_process(false)
	line.points[1] = Vector2.ZERO
	target_position = Vector2.ZERO
	sparks.emitting = false
	$Line2D.visible = false

func damage(ent):
	if ent.is_in_group("Player"):
		if ent.has_method("take_damage"):
			ent.take_damage(damage_value)

func _on_tick_timer_timeout():
	if is_hitting_target:
		var ent = get_collider()
		if ent:
			damage(ent)
