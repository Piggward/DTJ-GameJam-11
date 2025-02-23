extends Label

var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	player.gold_pickup.connect(_update_label)
	pass # Replace with function body.

func _update_label(value):
	self.text = str(value)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
