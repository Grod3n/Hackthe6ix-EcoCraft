extends Node2D

var enemy = preload("res://scenes/beast.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.




func _on_spawn_timer_timeout():
	var Enemy = enemy.instantiate()
	add_child(Enemy)
	Enemy.position = $Spawn.position
	
	var area = $SpawnArea
	var position = area.position + Vector2(randf() * area.size.x, randf() * area.size.y)
	$Spawn.position = position
	
