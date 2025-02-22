extends Node2D

var raycasts: Array[RayCast2D]
@export var raycasy_length: int
var player = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is RayCast2D:
			raycasts.append(child)
	pass # Replace with function body.
	
func chase():
	for r in raycasts:
		r.target_position.y = 400

func check_for_player():
	var player_collision = null
	for r in raycasts:
		if not r.is_colliding():
			continue
			
		var x = r.get_collider()
		if x:
			if x is Player:
				player_collision = x
				break
				
	player = player_collision
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_for_player()
	pass
