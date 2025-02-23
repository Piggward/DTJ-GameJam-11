extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_exited(body):
	pass # Replace with function body.


func _on_area_entered(area):
	if area is Enemy:
		area.queue_free()
	pass # Replace with function body.
