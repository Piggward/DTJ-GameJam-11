extends Area2D

@export var value: int
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body is Player and not picked_up:
		picked_up = true
		body.pickup_gold(value)
		self.visible = false
			
		var rpi = randf_range(0.9, 1.1)
		if value > 1:
			if value > 5:
				rpi += 0.4
			else:
				rpi += 0.2
		audio_stream_player_2d.set_pitch_scale(rpi)
		audio_stream_player_2d.play()
		await get_tree().create_timer(0.8).timeout
		self.queue_free()
	pass # Replace with function body.
