extends Sprite2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("ello")
	if body.is_in_group("Player"):
		#get_tree().quit()
		body.state = body.States.DEAD
