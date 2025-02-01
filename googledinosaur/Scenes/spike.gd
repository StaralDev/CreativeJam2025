extends Sprite2D

#func _process(_delta):
	#position.x += 1
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#get_tree().quit()
		body.state = body.States.DEAD
		#print("Player shouldn't be able to move now")
		
