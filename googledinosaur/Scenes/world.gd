extends Node2D

@export var latest_chunk: Node2D
@export var player: CharacterBody2D
var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_new_chunk():
	var new_chunk = preload("res://Scenes/chunk.tscn").instantiate()
	new_chunk.position = Vector2(latest_chunk.position.x + 784, 0)
	# Now that the chunk is here, add spikes along the points.
	for i in range(8):
		if rng.randi_range(0, 1): # here I am taking advantage of the fact that 0 evaluates to false
			continue
		for z in range(-1, rng.randi_range(0, 2)):
			print()
			var new_spike = load("res://Scenes/Spike.tscn").instantiate()
			new_spike.position = Vector2(i*200 + latest_chunk.position.x + 784 + 17*z, 157)
			self.add_child(new_spike)
	self.add_child(new_chunk)
	latest_chunk = new_chunk
	player.movement_speed *= 1.2 # will provide a more exponential speed than you would expect.
	print(player.movement_speed)
