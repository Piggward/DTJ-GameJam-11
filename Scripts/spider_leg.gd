extends Polygon2D

@onready var enemy = $"../.."
@export var bonus_rot: int

# Called when the node enters the scene tree for the first time.
func _ready():
	var rand = randf_range(0.0, 0.8)
	await get_tree().create_timer(rand).timeout
	ping_pong_leg(10)
	pass # Replace with function body.

func ping_pong_leg(value):
	self.polygon[0] += Vector2(0, -value).rotated(rotation - deg_to_rad(bonus_rot))
	await get_tree().create_timer(0.3).timeout
	if not enemy.dead:
		ping_pong_leg(-value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
