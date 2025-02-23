class_name Player
extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var animation_player: AnimationPlayer = $Torch/AnimationPlayer
var attacking = false
const TURN_SPEED = 10
var igniting = false
var bonfire_area: Bonfire
@onready var point_light_2d: Torch = $Torch/PointLight2D
var gold = 0
signal gold_pickup(gold: int)
var distance_travelled = 0.0
var in_safe_space = true
@onready var timer = $Torch/PointLight2D/Timer
@onready var level_2 = $".."
@onready var bonfire_indicator = $BonfireIndicator
var bonfire = Node2D
@onready var tutorial_text = $"../CanvasLayer/TutorialText/Label"
@onready var attack_sound = $AttackSound
@onready var ignite_sound = $IgniteSound

func indicator(value):
	bonfire_indicator.visible = value

func reset_distance():
	distance_travelled = 0.0
	
func _ready():
	bonfire = get_tree().get_first_node_in_group("bonfire")

func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		
	bonfire_indicator.rotation = global_position.angle_to_point(bonfire.global_position) - rotation + deg_to_rad(90)
	
	# Handle jump.
	if Input.is_action_just_pressed("action") and not attacking:
		attack()
		
	if Input.is_action_just_pressed("ignite") and not igniting:
		start_ignite()
		
	if Input.is_action_just_pressed("buy") and in_safe_space:
		if level_2.purchase_upgrade():
			timer.stop()
			point_light_2d.wait_time *= 1.1
			timer.set_wait_time(point_light_2d.wait_time)
			timer.start()
			
	if Input.is_action_just_pressed("win") and in_safe_space:
		if level_2.win_game():
			pass

	#if Input.is_action_just_released("ignite"):
		#igniting = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var zdirection := Input.get_axis("up", "down")
	#var new_rotation = rotation_degrees
	if direction:
		velocity.x = direction * SPEED
		#new_rotation = 90 * direction
		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if zdirection:
		velocity.y = zdirection * SPEED
		#new_rotation = 90 * (zdirection + 1)
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	#if new_rotation < 0:
		#new_rotation = 360 + new_rotation
		
	rotation += get_angle_to(get_global_mouse_position()) + deg_to_rad(90)
	if not in_safe_space:
		distance_travelled += abs(velocity.x) + abs(velocity.y)
	move_and_slide()
	
func pickup_gold(value: int):
	gold += value
	gold_pickup.emit(gold)
	
#func use_tinderbox():
	#g -= 1
	#tinderbox_pickup.emit(tinderboxes)
	#await get_tree().create_timer(1).timeout
	#ignite(3)
	#igniting = false
	
func start_ignite():
	igniting = true
	if bonfire_area:
		if bonfire_area.lit:
			ignite(100)
			return 
		else:
			bonfire_area.light_bonfire()
			return
	
func ignite(value: int):
	ignite_sound.play()
	point_light_2d.change_level(value)
	if (level_2.showing_tutorial):
		tutorial_text.text = "Come back often to reignite your torch. It's dangerous to venture in the dark..."
	igniting = false
	
func attack():
	attacking = true
	animation_player.play("torch_attack")
	attack_sound.play()
	await animation_player.animation_finished
	attacking = false
