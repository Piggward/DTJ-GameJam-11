class_name SpiderSpawner
extends Area2D

@export var max_time_until_spawn: float
@export var diff: float
const ENEMY = preload("res://Scenes/enemy.tscn")
@onready var collision_shape_2d = $CollisionShape2D
@export var spider_distance: float
var player: Player
var spawning = false
@onready var level_2 = $".."
@onready var label = $"../CanvasLayer/TutorialText/Label"
var first_time = true

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	pass # Replace with function body.
	
func set_timer():
	var randiff = randf_range(0, diff)
	if first_time:
		await get_tree().create_timer(5).timeout
	else:
		await get_tree().create_timer(max_time_until_spawn - randiff).timeout
	if spawning:
		spawn_spider()

func spawn_spider():
	var enemy = ENEMY.instantiate()
	add_child(enemy)
	var rp = randi_range(0, 359)
	enemy.global_position = player.global_position + Vector2(0, -spider_distance).rotated(deg_to_rad(rp))
	if first_time:
		enemy.speed = 0.8
		first_time = false
	else:
		enemy.speed = 1.2
	if level_2.showing_tutorial:
		label.text = "Use left mouse button to defend against creatures."
		await enemy.died
	print("setting timer")
	set_timer()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_safe_area_body_entered(body):
	if body is Player:
		spawning = false
		for child in get_children():
			if child is Enemy:
				child.die()
	pass # Replace with function body.


func _on_safe_area_body_exited(body):
	if body is Player:
		spawning = true
		set_timer()
	pass # Replace with function body.
