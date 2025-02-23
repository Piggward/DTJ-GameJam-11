class_name Enemy
extends Area2D

@onready var visuals: Node2D = $visuals
@export var speed: float
#@onready var ray_casts: Node2D = $RayCasts
var player: Player
var dead = false
@onready var burn_effect = $BurnEffect
@onready var burning = $BurnEffect/Burning

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	burn_effect.visible = false
	pass # Replace with function body.

#func enter_sight():
	#visuals.visible = true
	#
#func exit_sight():
	#visuals.visible = false
	
func die():
	dead = true
	burn_effect.visible = true
	burning.emitting = true
	await get_tree().create_timer(5).timeout
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if ray_casts.player:
	if not dead:
		self.rotation += get_angle_to(player.global_position)
		self.global_position += Vector2(0, -speed).rotated(rotation + deg_to_rad(90))
	pass
