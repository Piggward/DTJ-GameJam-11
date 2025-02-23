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
var tinderboxes = 0
signal tinderbox_pickup(tinderboxes: int)

func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	# Handle jump.
	if Input.is_action_just_pressed("action") and not attacking:
		attack()
		
	if Input.is_action_just_pressed("ignite") and not igniting:
		start_ignite()
			
	if Input.is_action_just_released("ignite"):
		igniting = false

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
	
	move_and_slide()
	
func pickup_tinderbox():
	tinderboxes += 1
	tinderbox_pickup.emit(tinderboxes)
	
func use_tinderbox():
	tinderboxes -= 1
	tinderbox_pickup.emit(tinderboxes)
	await get_tree().create_timer(1).timeout
	ignite(3)
	igniting = false
	
func start_ignite():
	igniting = true
	if bonfire_area:
		if bonfire_area.lit:
			ignite(100)
			return 
		else:
			bonfire_area.light_bonfire()
			return
	elif tinderboxes > 0:
		use_tinderbox()
	
func ignite(value: int):
	point_light_2d.change_level(value)
	
func attack():
	attacking = true
	animation_player.play("torch_attack")
	await get_tree().create_timer(1).timeout
	attacking = false
