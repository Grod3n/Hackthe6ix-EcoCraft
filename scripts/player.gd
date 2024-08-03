extends CharacterBody2D

const speed = 100
var current_dir = "none"
var is_dead = false
var health = 100
var max_health = 100  # Maximum health for the player
var tree_count = 0  # Variable to track the number of trees planted
var enemy_in_attack_range = false
var enemy_attack_cooldown = true
var attack_ip = false



@onready var tree_scene = preload("res://scenes/Tree.tscn")  # Preload the tree scene
@onready var tree_count_label = $"/root/MainScene/TreeCountLabel"  # Path to your tree count label

func _ready():
	update_tree_count_label()  # Initialize the tree count label
	print("TreeCountLabel Node: ", tree_count_label)

func _physics_process(delta):
	 
	player_movement(delta)
	enemy_attack()
	attack()
	
	if health <= 0:
		is_dead = true
		health = 0
		self.queue_free()

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
	if body.has_method("enemy"):
		enemy_in_attack_range = true

 
func _on_attack_area_body_exited(body):
	if body.has_method("enemy"):
		enemy_in_attack_range = false

func enemy_attack():
	if enemy_in_attack_range and enemy_attack_cooldown == true:
		health = health - 20
		enemy_attack_cooldown = false
		$attack_timer.start()
		print("did", health, "damage")

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




func spawn_tree():
	var tree_instance = tree_scene.instantiate()
	get_parent().add_child(tree_instance)
	tree_instance.global_position = global_position
	tree_count += 1
	update_tree_count_label()
	print("Tree spawned at: ", global_position)

func update_tree_count_label():
	if tree_count_label:
		tree_count_label.text = "Trees: " + str(tree_count)
		print("Tree count updated to: ", tree_count)
	else:
		print("Tree count label is null")
