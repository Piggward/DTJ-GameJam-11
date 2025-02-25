class_name Torch
extends PointLight2D

@onready var area_2d: Area2D = $Detector

@export var light_levels: Array[int]
@export var current_level: int
@onready var timer: Timer = $Timer
@export var wait_time: float
var level: Node2D
var has_shown_hint = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.set_wait_time(wait_time)
	set_light()
	timer.timeout.connect(timer_timeout)
	timer.start()
	flicker()
	level = get_tree().get_first_node_in_group("level")
	pass # Replace with function body.
	
func timer_timeout():
	change_level(-1)
	
func flicker():
	self.energy = randf_range(0.9, 1.1)
	await get_tree().create_timer(0.2).timeout
	flicker()
	
func change_level(value: int):
	current_level += value
	current_level = clamp(current_level, 0, light_levels.size()-1)
	set_light()
	timer.stop()
	timer.start()
	
	if current_level < 6 and not has_shown_hint:
		var player = get_tree().get_first_node_in_group("player")
		if not player.in_safe_space:	
			level.show_hint("You are running low on light. Return, Reignite, Resume.")
			has_shown_hint = true

func set_light():
	self.texture.width = light_levels[current_level]
	self.texture.height = light_levels[current_level]
	print("set light to ", light_levels[current_level])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
