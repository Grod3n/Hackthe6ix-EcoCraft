extends Control

func _ready():
	$Button.connect("pressed", Callable(self, "_on_PlayButton_pressed"))

func _on_PlayButton_pressed():
	get_tree().change_scene_to_file("res://scenes/game.tscn")
