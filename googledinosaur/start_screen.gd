extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#get_tree().paused = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		_on_button_pressed()
		



func _on_button_pressed() -> void:
	get_tree().paused = false
	get_parent().get_node("Dinosaur").canMove = true
	self.visible = false
	
