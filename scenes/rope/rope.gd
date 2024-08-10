extends Node2D

@export var ropeLength: float = 5
@export var pointCount: int = 20
@export var constrain: float = ropeLength / pointCount
@export var dampening: float = 0.95
@export var startPin: bool = true
@export var endPin: bool = true
@export var constrain_iterations: int = 1
@export var string_width: float = 12
@onready var line2D: = $Line2D

@export var ent1: Node2D
@export var ent2: Node2D

var gravity: Vector2 = Vector2(0, 25)
var pos: Array
var posPrev: Array

func _ready()->void:
	pos.resize(pointCount)
	posPrev.resize(pointCount)
	for i in range(pointCount):
		pos[i] = position + Vector2(constrain *i, 0)
		posPrev[i] = position + Vector2(constrain *i, 0)
	position = Vector2.ZERO
	line2D.width = string_width

func get_pointCount(distance: float)->int:
	return int(ceil(distance / constrain))

func _process(delta)->void:
	set_start(ent1)
	set_last(ent2)
	for i in range(constrain_iterations):
		update_points(delta)
		update_constrain()
	line2D.points = pos

func set_start(node: Node2D)->void:
	var gp = node.global_position
	if node.has_method("get_rope_point"):
		gp = node.get_rope_point()
	pos[0] = gp
	posPrev[0] = gp

func set_last(node: Node2D)->void:
	var sp = ent1.global_position
	var tp = ent2.global_position
	if ent1.has_method("get_rope_point"):
		sp = ent1.get_rope_point()
	if ent2.has_method("get_rope_point"):
		tp = ent2.get_rope_point()
	var dir = (tp - sp).normalized()
	var gp = ent1.global_position + (dir * ropeLength)
	pos[pointCount-1] = gp
	posPrev[pointCount-1] = gp

func update_points(delta)->void:
	for i in range (pointCount):
		if (i!=0 && i!=pointCount-1) || (i==0 && !startPin) || (i==pointCount-1 && !endPin):
			var velocity = (pos[i] -posPrev[i]) * dampening
			posPrev[i] = pos[i]
			pos[i] += velocity + (gravity * delta)

func update_constrain()->void:
	for i in range(pointCount):
		if i == pointCount-1:
			return
		var distance = pos[i].distance_to(pos[i+1])
		var difference = constrain - distance
		var percent = difference / distance
		var vec2 = pos[i+1] - pos[i]
		if i == 0:
			if startPin:
				pos[i+1] += vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
		elif i == pointCount-1:
			pass
		else:
			if i+1 == pointCount-1 && endPin:
				pos[i] -= vec2 * percent
			else:
				pos[i] -= vec2 * (percent/2)
				pos[i+1] += vec2 * (percent/2)
