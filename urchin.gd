extends StaticBody2D

func _on_area_2d_body_entered(body):
	if body.has_method("get_poisoned"):
		body.get_poisoned()
