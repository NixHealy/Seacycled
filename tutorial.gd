extends Node

var grace = true
var all_collected = true
var tutorial = true
var stage = 1
var poll_ctr = 0
var enemy_ctr = 0

func _ready():
	%MouseSprite.play()

func _process(delta):
	if stage == 1:
		if %Player.velocity.length() > 100 and %MovementTimer.is_stopped():
			%MovementTimer.start()
			
		if %TutPopup.visible == true:
			if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
				%TutPopup.visible = false
				spawn_pollution()
				stage = 2
				
	elif stage == 2:
		if %PollutionTimer.is_stopped():
			%PollutionTimer.start()
	
	elif stage == 3:
		if %EnemyTimer.is_stopped():
			%EnemyTimer.start()
	

func spawn_pollution():
	if poll_ctr < 2:
		var new_poll = preload("res://pollution.tscn").instantiate()
		%PollowPath.progress_ratio = randf()
		new_poll.global_position = %PollowPath.global_position
		add_child(new_poll)
		poll_ctr += 1
	else:
		%PollutionTimer.stop()
		stage = 3
		spawn_mob()

func spawn_mob():
	var new_mob = preload("res://trevally_enemy.tscn").instantiate()
	
	var numPath = randi_range(1, 2) #picks a random path to put it on
	if numPath == 1:
		%Path1.progress_ratio = randf() #chooses a point in the path
		new_mob.global_position = %Path1.global_position #and puts it there
	if numPath == 2:
		%Path2.progress_ratio = randf()
		new_mob.global_position = %Path2.global_position
	
	add_child(new_mob) #adds it to the scene

func _on_mouse_animation_finished():
	%MouseSprite.play()

func _on_movement_timer_timeout():
	%MouseSprite.visible = false
	if stage == 1:
		%TutPopup.visible = true

func _on_pollution_timer_timeout():
	spawn_pollution()

func _on_enemy_timer_timeout():
	if enemy_ctr < 5:
		spawn_mob()
		enemy_ctr += 1
