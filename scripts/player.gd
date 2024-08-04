extends CharacterBody2D

const speed = 60
var current_dir = "none"
var is_dead = false
var health = 100
var max_health = 100  # Maximum health for the player
var tree_count = 0  # Variable to track the number of trees planted
var house_count = 0
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var attack_ip = false
var tree_scene = preload("res://scenes/Tree.tscn")  # Ensure this is the correct path to your tree scene
var house_scene = preload("res://scenes/pixel_house.tscn")
var lose_scene = preload("res://scenes/GameWinScreen.tscn")


func _physics_process(delta):
	
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	check_plant_tree()
	check_build_house()
	
	if health <= 0:
		is_dead = true
		health = 0
		self.queue_free()
	if house_count >= 10:
		get_tree().change_scene_to_file("res://scenes/GameWinScreen.tscn")
		
func player_movement(delta):
	
		velocity = Vector2.ZERO

		if Input.is_action_pressed("ui_right"):
			current_dir = "right"
			animate(1)
			velocity.x = speed
		elif Input.is_action_pressed("ui_left"):
			current_dir = "left"
			animate(1)
			velocity.x = -speed
		elif Input.is_action_pressed("ui_down"):
			current_dir = "down"
			animate(1)
			velocity.y = speed
		elif Input.is_action_pressed("ui_up"):
			current_dir = "up"
			animate(1)
			velocity.y = -speed
		else:
			animate(0)
		move_and_slide()
		
func animate(movement):
	var dir = current_dir
	var animation = $AnimatedSprite2D

	if dir == "right":
		animation.flip_h = false
		if movement == 1:
				animation.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("side_idle")
		
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("side_idle")
		
	if dir == "up":
		if movement == 1:
			animation.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("back_idle")
		
	if dir == "down":
		if movement == 1:
			animation.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("front_idle")

func player():
	pass

func _on_attack_area_body_entered(body):
	if body.is_in_group("enemy"):
		enemy_in_attack_range = true

 
func _on_attack_area_body_exited(body):
	if body.is_in_group("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_timer.start()
		print("your health: ", health)

func _on_attack_timer_timeout():
	enemy_attack_cooldown = true



func attack():
	var dir = current_dir
	var animation = $AnimatedSprite2D
	
	if Input.is_action_just_pressed("attack"):
		Globalvar.player_current_attack = true
		attack_ip = true
		if dir == "right":
			animation.play("side_attack")
			$deal_attack_timer.start()
		elif dir == "left":
			animation.play("side_attack")
			$deal_attack_timer.start()
		elif dir == "up":
			animation.play("back_attack")
			$deal_attack_timer.start()
		elif dir == "down":
			animation.play("front_attack")
			$deal_attack_timer.start()  # Start the timer for the attack duration (adjust the duration as needed)

	
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	Globalvar.player_current_attack = false
	attack_ip = false



func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 100:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regin_timer_timeout():
	if health < 100:
		health = health + 20
		if health > 100:
			health = 100
	if health <= 0:
		health = 0

func check_plant_tree():
	if Input.is_action_just_pressed("ui_spawn_tree"):
		plant_tree()

func plant_tree():
	var tree = tree_scene.instantiate()  # Instance the tree scene
	tree.position = self.position * 1.1 # Set the tree's position to the player's current position
	get_parent().add_child(tree)  # Add the tree instance to the scene
	tree_count += 1
	print("Tree planted! Total trees planted: ", tree_count)
	
func check_build_house():
	if Input.is_action_just_pressed("ui_spawn_house"):
		build_house()
		
func build_house():
	var house = house_scene.instantiate()  # Instance the tree scene
	house.position = self.position # Set the tree's position to the player's current position
	get_parent().add_child(house)  # Add the tree instance to the scene
	house_count += 1
	print("House built! Total house planted: ", house_count)
