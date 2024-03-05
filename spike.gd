extends CharacterBody2D

func _physics_process(delta):
	velocity = Vector2(200, 0).rotated(rotation)
	move_and_slide()
