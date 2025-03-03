class_name Enemy
extends Area2D

@onready var visuals: Node2D = $visuals
@export var speed: float
#@onready var ray_casts: Node2D = $RayCasts
var player: Player
var dead = false
@onready var burn_effect = $BurnEffect
@onready var burning = $BurnEffect/Burning
var level: Node2D
var tutlabel: PanelContainer
signal died
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
const SPIDER_1 = preload("res://SFX/Spider1.wav")
const SPIDER_2 = preload("res://SFX/Spider2.wav")
const SPIDER_DIE_1 = preload("res://SFX/SpiderDie1.wav")
const SPIDER_DIE_2 = preload("res://SFX/SpiderDie2.wav")
@onready var walk_sound = $WalkSound

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	burn_effect.visible = false
	level = get_tree().get_first_node_in_group("level")
	tutlabel = get_tree().get_first_node_in_group("tutlabel")
	var random = randi_range(0, 1)
	if random == 0:
		audio_stream_player_2d.stream = SPIDER_1
	else:
		audio_stream_player_2d.stream = SPIDER_2
	var rpi = randf_range(0.9, 1.1)
	audio_stream_player_2d.set_pitch_scale(rpi)
	walk_sound.set_pitch_scale(rpi)
	audio_stream_player_2d.play()
	pass # Replace with function body.

#func enter_sight():
	#visuals.visible = true
	#
#func exit_sight():
	#visuals.visible = false
	
func die():
	if dead:
		return
	walk_sound.stop()
	var random = randi_range(0, 1)
	if random == 0:
		audio_stream_player_2d.stream = SPIDER_DIE_1
	else:
		audio_stream_player_2d.stream = SPIDER_DIE_2
	var rpi = randf_range(0.9, 1.1)
	audio_stream_player_2d.set_pitch_scale(rpi)
	audio_stream_player_2d.play()
	
	died.emit()
	if level.showing_tutorial:
		tutlabel.visible = false
		level.showing_tutorial = false
	dead = true
	burn_effect.visible = true
	burning.emitting = true
	await get_tree().create_timer(5).timeout
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if ray_casts.player:
	if not dead:
		self.rotation += get_angle_to(player.global_position)
		self.global_position += Vector2(0, -speed).rotated(rotation + deg_to_rad(90))
	pass


func _on_body_entered(body):
	if body is Player and not dead:
		if body.has_shield:
			body.lose_shield()
			self.die()
		else:
			var gameover = get_tree().get_first_node_in_group("gameover")
			gameover.visible = true
			level.process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.
