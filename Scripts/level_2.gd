extends Node2D

@export var gold_spawn_max_distance: float
@export var minimum_gold_spawn: float
@export var diff: float
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

var max_distance = 0.0
var current_distance_goal = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_first_node_in_group("player")
	max_distance = ruby_area.get_child(0).shape.radius
	set_distance_goal()
	update_shop()
	pass # Replace with function body.
	
func purchase_upgrade():
	if player.gold >= current_upgrade_cost:
		player.gold -= current_upgrade_cost
		gold_label = "Gold: " + str(player.gold)
		current_upgrade_cost += current_upgrade_cost + current_upgrade_cost / 2
		update_shop()
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
			tutorial_text = "Ignite your torch by pressing shift by the bonfire"
	pass # Replace with function body.


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
