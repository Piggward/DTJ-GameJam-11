extends Node2D

@onready var button = $CanvasLayer/VBoxContainer/Button
@onready var button_2 = $CanvasLayer/VBoxContainer/Button2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_up():
	get_tree().change_scene_to_file("res://Scenes/level_2.tscn")
	pass # Replace with function body.


func _on_button_2_button_up():
	get_tree().quit()
	pass # Replace with function body.
