extends Node2D

@export var gold_spawn_max_distance: float
@export var diff: float
const GOLD = preload("res://Scenes/gold_area.tscn")
var player: Player
var spawning = false
const SAPHIRE = preload("res://Scenes/saphire_area.tscn")
const RUBY_AREA = preload("res://Scenes/ruby_area.tscn")
@onready var bonfire = $Bonfire
@onready var gold_area = $GoldArea
@onready var saphire_area = $SaphireArea
@onready var ruby_area = $RubyArea


# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.

func spawn_gold():
	var gold = GOLD.instantiate()
	if (player.global_position - bonfire.global_position).length() > gold_area.get_child(0).shape.radius:
		gold = SAPHIRE.instantiate()
	add_child(gold)
	var rp = randi_range(0, 359)
	gold.global_position = player.global_position + Vector2(0, -450).rotated(deg_to_rad(rp))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player.distance_travelled >= gold_spawn_max_distance:
		player.reset_distance()
		spawn_gold()
	pass


func _on_safe_area_body_entered(body):
	if body is Player:
		print("enter")
		spawning = false
		body.in_safe_space = true
	
	pass # Replace with function body.


func _on_safe_area_body_exited(body):
	if body is Player:
		print("exit")
		spawning = true
		body.in_safe_space = false
	pass # Replace with function body.
