extends Control

func _ready():
	# Connect the restart button signal
	$Button.connect("pressed", Callable(self, "_on_RestartButton_pressed"))

func _on_RestartButton_pressed():
	# Reload the main game scene
	get_tree().change_scene_to_file("res://scenes/game.tscn")
