extends Node2D

@onready var audio_stream_player = $AudioStreamPlayer
const THANK_YOU_DAD = preload("res://SFX/thank_you_dad.mp3")
@export var gold_spawn_max_distance: float
@export var minimum_gold_spawn: float
@export var diff: float
@export var win_cost: int
const GOLD = preload("res://Scenes/gold_area.tscn")
var player: Player
var spawning = false
const SAPHIRE = preload("res://Scenes/saphire_area.tscn")
const RUBY = preload("res://Scenes/ruby_area.tscn")
@onready var bonfire = $Bonfire
@onready var gold_area = $GoldArea
@onready var saphire_area = $SaphireArea
@onready var ruby_area = $RubyArea
@onready var shop = $CanvasLayer/Shop
@onready var shop_label = $CanvasLayer/Shop/PanelContainer2/PanelContainer/Label
@onready var gold_label = $CanvasLayer/Label
var showing_tutorial = true
var current_upgrade_cost = 10
@onready var tutorial_text = $CanvasLayer/TutorialText/Label
@onready var tutorial_text_container = $CanvasLayer/TutorialText
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var win_container = $CanvasLayer/WinContainer
@onready var game_over_container = $CanvasLayer/GameOverContainer
@onready var game_over_label = $CanvasLayer/GameOverContainer/PanelContainer/VBoxContainer/Label
@onready var directional_light_2d = $Lighting/DirectionalLight2D
@onready var win_item = $CanvasLayer/Shop/PanelContainer3/PanelContainer/Label
@export var movement_speed_upgrade_cost: int
@export var player_gold: int
var m_upg = 0
@onready var m_upg_label = $CanvasLayer/Shop/MovementSpeedUpgrade/PanelContainer/Label
@onready var movement_speed_upgrade = $CanvasLayer/Shop/MovementSpeedUpgrade

var max_distance = 5700
var current_distance_goal = 0.0
@onready var spider_spawner = $SpiderSpawner

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	player.gold = player_gold
	set_distance_goal()
	update_shop()
	directional_light_2d.visible = true
	win_item.text = str(win_cost) + " GOLD 
(Press F to buy)"
	m_upg_label.text = str(movement_speed_upgrade_cost) + " GOLD 
(Press G to buy)"
	gold_label.text = str(player.gold)
	pass # Replace with function body.
	
func win_game():
	if player.gold >= 250:
		game_over_container.visible = true
		game_over_label.text = "You won!! You're the best dad ever!!"
		audio_stream_player_2d.stop()
		audio_stream_player_2d.stream = THANK_YOU_DAD
		audio_stream_player.play()
		self.process_mode = Node.PROCESS_MODE_DISABLED
		await get_tree().create_timer(3.5).timeout
		audio_stream_player.volume_db -= 6
		audio_stream_player_2d.play()
	
func purchase_upgrade():
	if player.gold >= current_upgrade_cost:
		player.gold -= current_upgrade_cost
		gold_label.text = str(player.gold)
		current_upgrade_cost += 3
		update_shop()
		return true
	else:
		return false
		
func purchase_movement():
	if m_upg == 2:
		return false
	if player.gold >= movement_speed_upgrade_cost:
		player.gold -= movement_speed_upgrade_cost
		gold_label.text = str(player.gold)
		movement_speed_upgrade_cost *= 1.5
		player.speed += 50
		m_upg_label.text = str(movement_speed_upgrade_cost) + " GOLD 
(Press G to buy)"
		m_upg += 1
		if m_upg == 2:
			movement_speed_upgrade.queue_free()
		return true
	else:
		return false
		
func purchase_shield():
	if player.has_shield:
		return false
	if player.gold >= 40:
		player.gold -= 40
		gold_label.text = str(player.gold)
		return true
	else:
		return false
	
func update_shop():
	shop_label.text = str(current_upgrade_cost) + " GOLD 
(Press B to buy)"

func spawn_gold():
	var gold = GOLD.instantiate()
	
	if gold_area.has_player:
		pass
	elif saphire_area.has_player:
		var dd = randi_range(0, 1)
		if dd == 1:
			gold = SAPHIRE.instantiate()
	elif ruby_area.has_player:
		var dd = randi_range(0, 5)
		if dd == 0:
			pass
		elif dd == 1:
			gold = RUBY.instantiate()
		else:
			gold = SAPHIRE.instantiate()
			
	add_child(gold)
	var rp = randi_range(0, 359)
	gold.global_position = player.global_position + Vector2(0, -450).rotated(deg_to_rad(rp))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	audio_stream_player_2d.global_position = player.global_position
	if player.distance_travelled >= current_distance_goal:
		player.reset_distance()
		set_distance_goal()
		spawn_gold()
	pass

func set_distance_goal():
	var distance_from_bonfire = (player.global_position - bonfire.global_position).length()
	var ratio = distance_from_bonfire / max_distance
	var max_reduction = (gold_spawn_max_distance - minimum_gold_spawn)
	current_distance_goal = gold_spawn_max_distance - max_reduction  * ratio

func _on_safe_area_body_entered(body):
	if body is Player:
		print("enter")
		shop.visible = true
		spawning = false
		body.in_safe_space = true
		body.indicator(false)
		if not showing_tutorial:
			tutorial_text_container.visible = true
			tutorial_text.text = "Ignite your torch by pressing shift by the bonfire"
	pass # Replace with function body.

func show_hint(value: String):
	tutorial_text_container.visible = true
	tutorial_text.text = value
	await get_tree().create_timer(4).timeout
	tutorial_text_container.visible = false
	

func _on_safe_area_body_exited(body):
	if body is Player:
		print("exit")
		shop.visible = false
		spawning = true
		body.in_safe_space = false
		body.indicator(true)
		
		if showing_tutorial:
			tutorial_text.text = "Rumor has it that the further you venture, the more valueble the treasure"
		else:
			tutorial_text_container.visible = false
		
	pass # Replace with function body.


func _on_play_again_button_up():
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
	pass # Replace with function body.


func _on_exit_button_up():
	get_tree().quit()
	pass # Replace with function body.
