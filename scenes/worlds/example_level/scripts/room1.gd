extends Node2D

@onready var directional_light_2d_darkness = $Lights/DirectionalLight2D_Darkness


func _ready() -> void:
	directional_light_2d_darkness.visible = true

func _process(delta: float) -> void:
	pass
