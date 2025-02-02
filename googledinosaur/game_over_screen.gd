extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		_on_button_pressed()


func _on_button_pressed() -> void:
	print("ME")
	get_tree().paused = false
	get_tree().reload_current_scene()
	Globa.Score = 0
	
