class_name Player
extends CharacterBody2D


var speed = 200.0
@onready var animation_player: AnimationPlayer = $Torch/AnimationPlayer
var attacking = false
const TURN_SPEED = 10
var igniting = false
var bonfire_area: Bonfire
@onready var point_light_2d: Torch = $Torch/PointLight2D
var gold = 25
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
var has_shield = false
@onready var shield = $Shield
var shop_ready = true

func add_shield():
	shield.visible = true
	has_shield = true

func lose_shield():
	shield.visible = false
	has_shield = false

func indicator(value):
	bonfire_indicator.visible = value

func reset_distance():
	distance_travelled = 0.0
	
func _ready():
	bonfire = get_tree().get_first_node_in_group("bonfire")
	lose_shield()
	
func set_shop_cd():
	#shop_ready = false
	#await get_tree().create_timer(0.2).timeout
	shop_ready = true

func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
	if bonfire:
		bonfire_indicator.rotation = global_position.angle_to_point(bonfire.global_position) - rotation + deg_to_rad(90)
	
	# Handle jump.
	if Input.is_action_just_pressed("action") and not attacking:
		attack()
		
	if Input.is_action_just_pressed("ignite"):
		start_ignite()
		
	if Input.is_action_just_pressed("buy") and in_safe_space and shop_ready:
		set_shop_cd()
		if level_2.purchase_upgrade():
			timer.stop()
			point_light_2d.wait_time *= 1.1
			timer.set_wait_time(point_light_2d.wait_time)
			timer.start()
			
	if Input.is_action_just_pressed("win") and in_safe_space and shop_ready:
		set_shop_cd()
		await level_2.win_game()
	
	if Input.is_action_just_pressed("movement_buff") and in_safe_space and shop_ready:
		set_shop_cd()
		if level_2.purchase_movement():
			pass
			
	if Input.is_action_just_pressed("shield") and in_safe_space and shop_ready:
		set_shop_cd()
		if level_2.purchase_shield():
			add_shield()

	#if Input.is_action_just_released("ignite"):
		#igniting = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	var zdirection := Input.get_axis("up", "down")
	#var new_rotation = rotation_degrees
	if direction:
		velocity.x = direction * speed
		#new_rotation = 90 * direction
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	if zdirection:
		velocity.y = zdirection * speed
		#new_rotation = 90 * (zdirection + 1)
	else:
		velocity.y = move_toward(velocity.y, 0, speed)
		
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
	if bonfire_area:
		ignite(100)
	
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
