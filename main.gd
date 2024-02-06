extends Node

var wave = 1

func _ready():
	%GameOver.visible = false
	%GraceLabel.visible = false

func _process(delta):
<<<<<<< HEAD
	%EnemyTimer.wait_time = pow(2, -wave) #definitely wanna adjust the timing on this
=======
	%EnemyTimer.wait_time = (sin((wave+5)/2)+1.1)*(15/(wave+5)) #definitely wanna adjust the timing on this
>>>>>>> c68f4d7409961a44cb8e4d5faa017aaa3b5c68bd
	
	if %ProgressBar.value >= 100:
		%ProgressBar.value = 0
		wave += 1
		%WaveLabel.text = "Wave " + str(wave)
		
	%GraceLabel.text = str(roundi(%GraceTimer.time_left))

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

func _on_timer_timeout(): #timer between mob spawns
	spawn_mob() 

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
<<<<<<< HEAD
=======
		%Coral.health = 100
>>>>>>> c68f4d7409961a44cb8e4d5faa017aaa3b5c68bd
		
		%GraceTimer.start() #start a timer for the grace period
		%GraceLabel.visible = true

func _on_reset_button_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_grace_timer_timeout():
	%WaveTimer.start()
	%EnemyTimer.start()
	%GraceLabel.visible = false
