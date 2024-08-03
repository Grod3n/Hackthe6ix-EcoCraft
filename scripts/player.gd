extends CharacterBody2D

const speed = 100
var current_dir = "none"

func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	player_movement(delta)

func player_movement(delta):
	if Input.is_action_pressed("ui_right"):
		current_dir = "right"
		animate(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_left"):
		current_dir = "left"
		animate(1)
		velocity.x = -speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_down"):
		current_dir = "down"
		animate(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_up"):
		current_dir = "up"
		animate(1)
		velocity.x = 0
		velocity.y = -speed
	else:
		animate(0)
		velocity.x = 0
		velocity.y = 0
		
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
