class_name Torch
extends PointLight2D

@onready var area_2d: Area2D = $Detector

@export var light_levels: Array[int]
@export var current_level: int
@onready var timer: Timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_light()
	timer.timeout.connect(timer_timeout)
	timer.start()
	flicker()
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

func set_light():
	self.texture.width = light_levels[current_level]
	self.texture.height = light_levels[current_level]
	print("set light to ", light_levels[current_level])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
