extends Node

var wave = 1

func _ready():
	%GameOver.visible = false
	%GraceLabel.visible = false

func _process(delta):
	%EnemyTimer.wait_time = 1 - 0.1 * wave #definitely wanna adjust the timing on this
	
	if %ProgressBar.value >= 100:
		%ProgressBar.value = 0
		wave += 1
		%WaveLabel.text = "Wave " + str(wave)
		
	%GraceLabel.text = str(roundi(%GraceTimer.time_left))
	%ChumkLabel.text = "Chumks: " + str(%Player.chumks)

func spawn_mob():
	var new_mob = preload("res://enemy.tscn").instantiate() #makes an enemy
	var num = randi_range(1, 2) #picks a random path to put it on
	
	if num == 1:
		%Path1.progress_ratio = randf() #chooses a point in the path
		new_mob.global_position = %Path1.global_position #and puts it there
	if num == 2:
		%Path2.progress_ratio = randf()
		new_mob.global_position = %Path2.global_position
	
	add_child(new_mob) #adds it to the scene
	
func spawn_pollution():
	var new_poll = preload("res://pollution.tscn").instantiate()
	%PollowPath.progress_ratio = randf()
	new_poll.global_position = %PollowPath.global_position
	
	add_child(new_poll)

func _on_timer_timeout(): #timer between mob spawns
	spawn_mob() 
	spawn_pollution()

func _on_coral_died(): #oh no the coral is dead
	%GameOver.visible = true #show the game over screen
	get_tree().paused = true

func _on_wave_timer_timeout():
	%ProgressBar.value += 1
	
	if %ProgressBar.value >= 100: #if the wave is done
		%WaveTimer.stop()
		%EnemyTimer.stop()
		
		var enemies = get_tree().get_nodes_in_group("enemy") #delete all the enemies
		for enemy in enemies:
			enemy.queue_free()
		var pollutions = get_tree().get_nodes_in_group("pollution") #delete all the enemies
		for pollution in pollutions:
			pollution.queue_free()
		%Coral.health = 100
		
		%GraceTimer.start() #start a timer for the grace period
		%GraceLabel.visible = true

func _on_reset_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_grace_timer_timeout():
	%WaveTimer.start()
	%EnemyTimer.start()
	%GraceLabel.visible = false
