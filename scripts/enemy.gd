extends CharacterBody2D

var speed = 30  # Adjusted speed for debugging purposes
var player_chase = false
var player = null
var health = 50
var player_inattack_range = false
var can_take_damage = true

# Random movement variables
var random_move_time = 0
var move_direction = Vector2()

func _ready():
	randomize()

func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if player_chase:
		chase_player(delta)
		move_and_collide(Vector2(0,0))
	else:
		random_movement(delta)
		move_and_collide(Vector2(0,0))
		
	animate()

func chase_player(delta):
	if player:
		
		print("chasing")
		# Determine if the player is closer in the X or Y direction
		var horizontal_distance = abs(player.position.x - position.x)
		var vertical_distance = abs(player.position.y - position.y)
		
		if horizontal_distance > vertical_distance:
			# Move horizontally
			move_direction = Vector2(sign(player.position.x - position.x), 0)
		else:
			# Move vertically
			move_direction = Vector2(0, sign(player.position.y - position.y))
		
		position += move_direction * (speed+15) * delta
		
func random_movement(delta):
	random_move_time -= delta
	if random_move_time <= 0:
		# Choose either horizontal or vertical movement randomly
		if randf() > 0.5:
			move_direction = Vector2(randf_range(-1, 1), 0).normalized()  # Horizontal movement
		else:
			move_direction = Vector2(0, randf_range(-1, 1)).normalized()  # Vertical movement
		random_move_time = randf_range(1, 3)  # Random movement interval
	
	position += move_direction * speed * delta

func animate():
	if move_direction.y > 0:
		$AnimatedSprite2D.play("front_walk")
	elif move_direction.y < 0:
		$AnimatedSprite2D.play("back_walk")
	elif move_direction.x > 0:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("side_walk")
	else:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("side_walk")

func _on_detection_area_body_entered(body):

		player = body
		player_chase = true

func _on_detection_area_body_exited(body):

		player = null
		player_chase = false

func _on_enemy_hitbox_body_entered(body):
	if body.is_in_group("player"):
		player_inattack_range = true

func _on_enemy_hitbox_body_exited(body):
	if body.is_in_group("player"):
		player_inattack_range = false

func deal_with_damage():
	if player_inattack_range and Globalvar.player_current_attack:
		if can_take_damage:
			health -= 20
			$DamageTimer.start()
			can_take_damage = false
			print("enemy health:", health)
			if health <= 0:
				queue_free()

func _on_damage_timer_timeout():
	can_take_damage = true

func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 100:
		health += 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0
