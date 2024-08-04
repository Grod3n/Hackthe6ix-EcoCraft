extends TextureProgressBar

@onready var timer = get_node("../../SpawnTimer")
var elapsed_time = 0.0  # Variable to track elapsed time

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if timer:
		print("SpawnTimer Node: ", timer)
	else:
		print("SpawnTimer Node not found.")
	update()

func update():
	if timer:
		value = (20 - timer.wait_time) * 5
		print(timer.wait_time)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer:
		elapsed_time += delta  # Increment elapsed time by the time since last frame
		
		if elapsed_time >= 3.0:  # Check if 10 seconds have passed
			timer.wait_time -= 0.4  # Increment wait_time by 1
			elapsed_time = 0.0  # Reset elapsed time
			update()  # Update the display or other related elements if needed
