extends Node2D

@export var latest_chunk: Node2D
@export var player: CharacterBody2D
var rng = RandomNumberGenerator.new()
var chunks = []
var chair = load("res://Chair.tscn")
var table = load("res://Table.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node("Dinosaur")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func add_new_chunk(chunk):
	if len(chunks) == 0:
		chunks.append(chunk)

	var new_chunk = preload("res://Scenes/chunk.tscn").instantiate()
	new_chunk.position = Vector2(latest_chunk.position.x + 784, 0)
	# Now that the chunk is here, add spikes along the points.
	for i in range(8):
		var spikes = []
		if rng.randi_range(0, 1): # here I am taking advantage of the fact that 0 evaluates to false
			if not rng.randi_range(0, 9) || player.am_duck:
				continue
			var new_egg = load("res://Egg.tscn").instantiate()
			new_egg.position = Vector2(i*200 +latest_chunk.position.x + 748, 111)
			self.add_child(new_egg)
		for z in range(-1, rng.randi_range(0, 2)):
			spikes.append(1)
			
		print(spikes)
		if len(spikes) == 1:
			spawnChairs(Vector2(i*200 + latest_chunk.position.x + 784 + 17, 147))
		elif len(spikes) == 2:
			spawnTables(Vector2(i*200 + latest_chunk.position.x + 784 + 17, 132))
		elif len(spikes) == 2:
			if rng.randi_range(0, 1) == 0:
				spawnTables(Vector2(i*200 + latest_chunk.position.x + 784 + 17, 132))
				spawnChairs(Vector2(i*200 + latest_chunk.position.x + 784 + 21, 147))
			else:
				spawnChairs(Vector2(i*200 + latest_chunk.position.x + 784 + 17, 147))
				spawnTables(Vector2(i*200 + latest_chunk.position.x + 784 + 14, 132))
		
	self.add_child(new_chunk)
	latest_chunk = new_chunk
	player.movement_speed += player.movement_speed * 0.1 # will provide a more exponential speed than you would expect.
	chunks.append(latest_chunk)
	print(player.movement_speed)
	
	if len(chunks) > 2:
		delete_previous_chunk()
	
	Globa.Score += 100

func delete_previous_chunk():
	chunks.remove_at(0)
	print(chunks)
	
func spawnChairs(spawnPosition):
	var new_chair = chair.instantiate()
	new_chair.position = spawnPosition
	self.add_child(new_chair)
	
func spawnTables(spawnPosition):
	var new_table = table.instantiate()
	new_table.position = spawnPosition
	self.add_child(new_table)
