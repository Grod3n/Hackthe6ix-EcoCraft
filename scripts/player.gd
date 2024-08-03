extends CharacterBody2D

const speed = 100
var current_dir = "none"
var is_attacking = false
var is_dead = false
var health = 100
var max_health = 100  # Maximum health for the player
var tree_count = 0  # Variable to track the number of trees planted

@onready var attack_area = $AttackArea
@onready var health_bar = $HealthBar  # Reference to the health bar
@onready var tree_scene = preload("res://scenes/Tree.tscn")  # Preload the tree scene
@onready var tree_count_label = $"/root/MainScene/TreeCountLabel"  # Path to your tree count label

func _ready():
	$AnimatedSprite2D.play("front_idle")
	$AttackTimer.timeout.connect(Callable(self, "_on_AttackTimer_timeout"))
	add_to_group("player")  # Ensure the player is in the "player" group
	update_health_bar()  # Update the health display
	update_tree_count_label()  # Initialize the tree count label
	print("TreeCountLabel Node: ", tree_count_label)

func _physics_process(delta):
	if is_dead:
		return
	player_movement(delta)
	if Input.is_action_just_pressed("attack") and not is_attacking:
		attack()
	if Input.is_action_just_pressed("ui_spawn_tree"):
		spawn_tree()

func player_movement(delta):
	if not is_attacking:
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
		else:
			animation.play("side_idle")
			
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("side_walk")
		else:
			animation.play("side_idle")
			
	if dir == "up":
		if movement == 1:
			animation.play("back_walk")
		else:
			animation.play("back_idle")
			
	if dir == "down":
		if movement == 1:
			animation.play("front_walk")
		else:
			animation.play("front_idle")

func attack():
	is_attacking = true
	var animation = $AnimatedSprite2D

	if current_dir == "right":
		animation.play("side_attack")
	elif current_dir == "left":
		animation.play("side_attack")
	elif current_dir == "up":
		animation.play("back_attack")
	elif current_dir == "down":
		animation.play("front_attack")

	$AttackTimer.start(0.5)  # Start the timer for the attack duration (adjust the duration as needed)

	# Detect collision with enemy
	for body in attack_area.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			body.take_damage(10)  # Deal 10 damage to the enemy
			print("Dealing 10 damage to enemy: ", body)

func _on_AttackTimer_timeout():
	is_attacking = false

func take_damage(amount):
	health -= amount
	update_health_bar()
	print("Player health: ", health)
	if health <= 0:
		die()

func update_health_bar():
	if health_bar != null:
		health_bar.value = health
	else:
		print("Health bar is null")

func die():
	if is_dead:
		return  # Prevent multiple calls to die()
	is_dead = true
	var animation = $AnimatedSprite2D
	animation.play("death")
	$AnimatedSprite2D.animation_finished.connect(Callable(self, "_on_death_animation_finished"))
	print("Player has died")

func _on_death_animation_finished():
	if $AnimatedSprite2D.animation == "death" and is_dead:
		# Load the Game Over screen
		get_tree().change_scene_to_file("res://path_to_your_game_over_scene.tscn")
		print("Player removed from scene")

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
