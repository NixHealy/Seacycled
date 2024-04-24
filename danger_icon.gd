extends Sprite2D

func _ready():
	if global_position.x > 500:
		flip_h = true

func _on_timer_timeout():
	queue_free()
