extends Enemy

#@onready var coral = get_node("/root/Main/Coral") #fetches the coral node

func _ready():
	global_position.y = 420
	health = 1
	speed = 80

func _physics_process(delta):
	if health <= 0:
		die()

	# Move the crab only along the x-axis
	var direction = global_position.direction_to(coral.global_position)
	velocity.x = direction.x * speed
	velocity.y = 0 # Ensure no movement along the y-axis
	
	if stunned == false:
		move_and_slide()
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func take_damage():
	health -= 1
	modulate = Color(1, 0.5, 0.5, 1)
		
func die(): #oh no its dead
	if is_in_group("enemy"):
		var new_chumk = preload("res://chumk.tscn").instantiate()
		add_child(new_chumk)
		new_chumk.global_scale = Vector2(1, 1)
		new_chumk.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()
