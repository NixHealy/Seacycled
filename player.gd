extends CharacterBody2D

@onready var main = get_node("/root/Main")

var norm_tex = load("res://img/fish.png")
var att_tex = load("res://img/attack.png")

var attacking = false
var speed = 3
var chumks = 0

func _ready():
	%Hit.visible = false
	for node in %Outline.get_children():
		node.modulate.v = 15

func _physics_process(delta):
	
	if Input.is_action_just_pressed("attack") and %AttackTimer.is_stopped() and %CooldownTimer.time_left == 0: #might wanna change this so its a quick attack
		#%Fish.set_texture(att_tex)						  #instead of lasting as long as you hold it
		%Hit.visible = true
		%AttackTimer.start()
		%AttackSound.play()
		attacking = true
	
	var direction
	
	#if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT): 
	direction = get_viewport().get_mouse_position() - get_global_transform_with_canvas().get_origin()
	velocity = direction * speed * (log(direction.length()) / log(2)) #faster when mouse is futher away
	if velocity.length() < 100:
		%MoveSound.volume_db = -100.0
	else:
		%MoveSound.volume_db = 0.2
	
	# -- working on keyboard controls, work on this later --
	#if Input.is_action_pressed("move_up"):
		#velocity = Vector2(0, -10000 * delta)
	#if Input.is_action_pressed("move_down"):
		#velocity = Vector2(0, 10000 * delta)
	#if Input.is_action_pressed("move_left"):
		#velocity = Vector2(-10000 * delta, 0)
	#if Input.is_action_pressed("move_right"):
		#velocity = Vector2(10000 * delta, 0)
	#if Input.is_anything_pressed() == false:
		#velocity = Vector2(0, 0)
		
	move_and_slide()
	

	%Fish.rotation = atan(velocity.y / velocity.x) #removed because it wasnt playing nice with collision
	#%Fish.rotation_degrees = snapped(rotation_degrees, 45)
	%HitMarker.rotation = %Fish.rotation
		
	if velocity.x > 0:
		%Fish.flip_h = true
		%Hit.flip_h = true
		for node in %Outline.get_children():
			node.flip_h = true
		%HitArea.position.x = 54 #should really be relative position
	else:
		%Fish.flip_h = false
		%Hit.flip_h = false
		for node in %Outline.get_children():
			node.flip_h = false
		%HitArea.position.x = -54
			
	var ctr = %HitArea.get_overlapping_bodies().size()
	for body in %HitArea.get_overlapping_bodies(): #for everything nearby
		if attacking == true:
			if body.has_method("take_damage"): #just to check
				body.take_damage() #ASSAULT
				ctr -= 1
				if ctr == 0:
					attacking = false
		
	for area in %CollectionArea.get_overlapping_areas():
		if area.is_in_group("collectable"):
			if main.grace == true:
				area.queue_free()
				chumks += 1
				
	for body in %CollectionArea.get_overlapping_bodies():
		if body.is_in_group("enemy") or body.is_in_group("pollution"):
			if not body.is_in_group("spike"):
				if %ClicklessTimer.is_stopped() == true and attacking == false and body.health > 0:
					%ClicklessTimer.start()

	var polluted = false

	for body in %PollutionDetector.get_overlapping_bodies():
		if body.is_in_group("pollution"):
			polluted = true
		
	if polluted == true:
		speed = 1
		modulate = Color(0.5, 0.5, 0.5, 1.0)
	else:
		speed = 3
		modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_attack_timer_timeout():
	attacking = false
	#%Fish.set_texture(norm_tex)
	%Hit.visible = false
	%CooldownTimer.start() # Replace with function body.

#func _on_collection_area_body_entered(body):
	#if body.is_in_group("enemy") or body.is_in_group("pollution"):
		#%ClicklessTimer.start()

#func _on_collection_area_body_exited(body):
	#%ClicklessTimer.stop()

func _on_clickless_timer_timeout():
	if %CooldownTimer.time_left == 0:
		%Hit.visible = true
		%AttackTimer.start()
		attacking = true
		%AttackSound.play()
		%ClicklessTimer.stop()


func _on_move_sound_finished():
	%MoveSound.play()
