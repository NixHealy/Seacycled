extends Enemy

var exp_tex = load("res://img/puffer_enemy_explode.png")

func _ready():
	speed = 50.0

func _physics_process(delta):
	if health <= 0:
		die()
	
	var direction = coral.global_position - global_position  #goes to the coral
	velocity = direction.normalized() * speed
	
	if direction.length() < 500:
		%InflateSound.play()
		%Sprite2D.set_texture(exp_tex)
		if %ExplodeTimer.is_stopped() == true:
			%ExplodeTimer.start()
	
	if stunned == false and direction.length() > 500:
		move_and_slide()

	if %ExplodeTimer.is_stopped() == false:
		scale = scale * 1.01

	#%Sprite2D.rotation = atan(velocity.y / velocity.x) #temporarily removed because it was not playing nice with collision
	#rotation_degrees = snapped(rotation_degrees, 45) 
	
	if velocity.x > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func take_damage():
	health -= 1
	modulate = Color(1, 0.5, 0.5, 1)
		
func die(): #oh no its dead
	var chanceToDrop = randi_range(1,1)
	if is_in_group("enemy") && chanceToDrop == 1:
		var new_chumk = preload("res://chumk.tscn").instantiate()
		add_child(new_chumk)
		new_chumk.global_scale = Vector2(1, 1)
		new_chumk.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()

func explode():
	for i in range(8):
		var spike = preload("res://spike.tscn").instantiate()
		spike.rotation_degrees = 45 * i
		add_child(spike)
		spike.global_scale = Vector2(1, 1)
		spike.reparent(get_node("/root/Main"))
	queue_free()
	died.emit()

func _on_explode_timer_timeout():
	%PopSound.play()
	explode()
