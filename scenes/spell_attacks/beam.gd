extends RayCast2D

@onready var line = $Line2D
@onready var line_2d_2 = $Line2D2
@onready var line_2d_3 = $Line2D3
@onready var line_2d_4 = $Line2D4
@onready var tick_timer = $TickTimer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var sprite_2d = $Sprite2D

var end_ball_base_scale = 0.5
var width = 16.0

const max_range = 2000
const base_dps = 500
const base_tps = 30
var is_hitting_target = false
var damage_value = 0

var harm = false

func _ready():
	set_physics_process(false)
	set_line_points(Vector2.ZERO)
	tick_timer.wait_time = 1.0 / base_tps
	damage_value = base_dps / base_tps
	set_line_visible(false)
	sprite_2d.visible = false

func _physics_process(delta):
	target_position = Vector2.RIGHT * max_range
	force_raycast_update()
	if is_colliding():
		target_position = to_local( get_collision_point() )
		if not is_hitting_target:
			tick_timer.start()
			is_hitting_target = true
	else:
		tick_timer.stop()
		is_hitting_target = false
	set_line_points(target_position)
	line.width = width * 0.25
	line_2d_2.width = width / 2.0
	line_2d_3.width = width * 0.75
	line_2d_4.width = width
	
	sprite_2d.scale = Vector2(1, 1) * end_ball_base_scale * (width / 16)

func activate():
	set_physics_process(true)
	set_line_visible(true)
	sprite_2d.visible = true
	if !audio_stream_player_2d.playing:
		audio_stream_player_2d.play()

func deactivate():
	set_line_points(Vector2.ZERO)
	target_position = Vector2.ZERO
	set_line_visible(false)
	sprite_2d.visible = false
	if audio_stream_player_2d.playing:
		audio_stream_player_2d.stop()
	#set_physics_process(false)

func _on_tick_timer_timeout():
	if harm and is_hitting_target:
		var ent = get_collider()
		if ent.is_in_group("Player") and ent.has_method("take_damage"):
			ent.take_damage(damage_value)

func set_line_points(pos):
	line.points[1] = pos
	line_2d_2.points[1] = pos
	line_2d_3.points[1] = pos
	line_2d_4.points[1] = pos
	
	sprite_2d.position = pos

func set_line_visible(visible):
	line.visible = visible
	line_2d_2.visible = visible
	line_2d_3.visible = visible
	line_2d_4.visible = visible

func set_line_width(value):
	width = value
