class_name Bonfire
extends Node2D

@export var lit: bool
@onready var fire: Node2D = $Fire
@onready var point_light_2d: PointLight2D = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#fire.visible = lit
	point_light_2d.visible = lit
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func light_bonfire():
	lit = true
	fire.visible = lit
	point_light_2d.visible = lit

func _on_bonfire_area_body_entered(body: Node2D) -> void:
	if body is Player:
		body.bonfire_area = self
	pass # Replace with function body.


func _on_bonfire_area_body_exited(body: Node2D) -> void:
	if body is Player and body.bonfire_area == self:
		body.bonfire_area = null
	pass # Replace with function body.
