class_name Enemy
extends Area2D

@onready var visuals: Node2D = $visuals
@onready var ray_casts: Node2D = $RayCasts

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func enter_sight():
	visuals.visible = true
	
func exit_sight():
	visuals.visible = false
	
func die():
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ray_casts.player:
		self.rotation += get_angle_to(ray_casts.player.global_position)
		self.global_position += Vector2(0, -3).rotated(rotation + deg_to_rad(90))
	pass
