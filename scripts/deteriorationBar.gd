extends TextureProgressBar

@onready var timer = get_node("../../SpawnTimer")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update()

func update():
	value = timer.wait_time * 10

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
