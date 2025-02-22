extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	disable(true)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func disable(value: bool):
	collision_shape_2d.set_deferred("disabled", value)
	

func _on_area_entered(area: Area2D) -> void:
	if area is Enemy:
		area.die()
	pass # Replace with function body.
