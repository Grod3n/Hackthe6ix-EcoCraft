extends CharacterBody2D

var speed = 25  # Its a little bit fast for debugging purposes
var player_chase = false
var player = null
var health = 50
var max_health = 50  
var player_inattack_range = false
var can_take_damage = true




func _physics_process(delta):
	
	deal_with_damage()
	
	if player_chase:
		position += (player.position - position)/speed

		$AnimatedSprite2D.play("side_walk")
		
		if (player.position.x - position.x) > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

func _on_detection_area_body_entered(body):
		player = body
		player_chase = true
		

func _on_detection_area_body_exited(body):
		player = null
		player_chase = false

func enemy():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_range = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_range = false


func deal_with_damage():
	if player_inattack_range and Globalvar.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$DamageTimer.start()
			can_take_damage = false
			print("enemy health:", health)
			if health <= 0:
				self.queue_free()

func _on_damage_timer_timeout():
	can_take_damage = true
	










	
