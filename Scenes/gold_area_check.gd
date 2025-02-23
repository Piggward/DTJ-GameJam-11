extends Area2D

var has_player: bool
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	if body is Player:
		has_player = true
	pass # Replace with function body.


func _on_body_exited(body):
	if body is Player:
		has_player = false
	pass # Replace with function body.
