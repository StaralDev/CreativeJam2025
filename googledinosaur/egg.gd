extends Sprite2D





func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.to_duck()
		print("World")
		self.queue_free()
