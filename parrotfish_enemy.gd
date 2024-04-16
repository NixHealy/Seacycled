extends Enemy

var maxhealth = 4.0

func _ready():
	health = 4.0
	speed = 40.0
	
	if FileAccess.file_exists("user://options.ini"):
		config.load("user://options.ini")
		var contrast = false
		contrast = config.get_value("Options", "contrast")
		%Sprite2D.material.set_shader_parameter("active", contrast)

func _physics_process(delta):
		
	if health <= 0:
		die()
	
	var direction = coral.global_position - global_position  #goes to the coral
	if direction.length_squared() > 500000:
		direction = Vector2(direction.x, 0)
		velocity = direction.normalized() * speed
	
	if stunned == false:
		move_and_slide()

	rotation = atan(velocity.y / velocity.x) #temporarily removed because it was not playing nice with collision
	#rotation_degrees = snapped(rotation_degrees, 45) 
	
	if velocity.x > 0:
		$Sprite2D.flip_h = true
		for node in %Outline.get_children():
			node.flip_h = true
	else:
		$Sprite2D.flip_h = false
		for node in %Outline.get_children():
			node.flip_h = false
		
func take_damage():
	health -= 1
	modulate = Color(1, health / maxhealth, health / maxhealth, 1)
		
func die(): #oh no its dead
	var chanceToDrop = randi_range(1,1)
	if is_in_group("enemy") && chanceToDrop == 1:
		var new_chumk = preload("res://chumk.tscn").instantiate()
		add_child(new_chumk)
		new_chumk.global_scale = Vector2(1, 1)
		new_chumk.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()
