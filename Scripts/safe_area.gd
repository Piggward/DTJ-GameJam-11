extends Area2D

@onready var shop = $"../CanvasLayer/Node2D"
var player: Player
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_exited(body):
	pass # Replace with function body.


func _on_area_entered(area):
	if area is Enemy:
		area.die()
	pass # Replace with function body.
