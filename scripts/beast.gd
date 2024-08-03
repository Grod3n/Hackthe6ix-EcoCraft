extends CharacterBody2D

var speed = 50  # Its a little bit fast for debugging purposes
var player_chase = false
var player = null
var health = 50
var max_health = 50  
var repulsion_force = 50  
var damage_per_tick = 5  

@onready var detection_area = $DetectionArea
@onready var health_bar = $HealthBar  
@onready var damage_timer = $DamageTimer  

func _ready():
	detection_area.body_entered.connect(Callable(self, "_on_detection_area_body_entered"))
	detection_area.body_exited.connect(Callable(self, "_on_detection_area_body_exited"))
	damage_timer.timeout.connect(Callable(self, "_on_damage_timer_timeout"))
	update_health_bar()  # broken???

func _physics_process(delta):
	if player_chase and player != null:
		var direction = (player.position - position).normalized()
		velocity = direction * speed
		
		if position.distance_to(player.position) < 10:
			var repulsion = (position - player.position).normalized() * repulsion_force
			velocity += repulsion

		move_and_slide()

		$AnimatedSprite2D.play("side_walk")
		
		if direction.x > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_chase = true
		damage_timer.start() 
		print("Player detected, starting damage timer")

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		player = null
		player_chase = false
		damage_timer.stop()
		print("Player lost, stopping damage timer")

func _on_damage_timer_timeout():
	if player != null:
		player.take_damage(damage_per_tick)  
		print("Dealing damage to player: ", damage_per_tick)

func take_damage(amount):
	health -= amount
	update_health_bar()
	print("Enemy health: ", health)
	if health <= 0:
		die()

func update_health_bar():
	if health_bar != null:
		health_bar.value = health
	else:
		print("Health bar is null")

func die():
	queue_free() # enemy can't take damage for some reason
	print("Enemy has died")
